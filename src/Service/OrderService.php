<?php

namespace App\Service;

use App\Entity\Contact;
use App\Entity\Item;
use App\Entity\Order;
use App\Entity\OrderLine;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;
use RuntimeException;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Contracts\HttpClient\Exception\ClientExceptionInterface;
use Symfony\Contracts\HttpClient\Exception\DecodingExceptionInterface;
use Symfony\Contracts\HttpClient\Exception\RedirectionExceptionInterface;
use Symfony\Contracts\HttpClient\Exception\ServerExceptionInterface;
use Symfony\Contracts\HttpClient\Exception\TransportExceptionInterface;
use Symfony\Contracts\HttpClient\HttpClientInterface;

class OrderService
{

    /**
     * @var HttpClientInterface
     */
    private $client;

    /**
     * @var EntityManagerInterface
     */
    private $em;

    private $container;

    private $logger;


    /**
     * @param EntityManagerInterface $em
     * @param HttpClientInterface $client
     * @param ContainerInterface $container
     * @param LoggerInterface $logger
     */
    public function __construct(EntityManagerInterface $em, HttpClientInterface $client, ContainerInterface $container, LoggerInterface $logger)
    {
        $this->client = $client;
        $this->em = $em;
        $this->container = $container;
        $this->logger = $logger;
    }


    /**
     * @throws ServerExceptionInterface
     * @throws RedirectionExceptionInterface
     * @throws DecodingExceptionInterface
     * @throws ClientExceptionInterface
     */
    public function retrieveOrders(): ?array
    {
        try {
            $newSavedOrder = [];
            $this->logger->info("---------------Retrieving New Orders-----------------");
            $this->logger->info("Trying to call api for retrieving orders...");
            // get orders response from api
            $apiResponse = $this->client->request(
                Request::METHOD_GET,
                "{$this->container->getParameter('app.api_url')}/orders",
                [
                    'headers' => [
                        'x-api-key' => $this->container->getParameter('app.api_key')
                    ]
                ]
            );

            // if response other than 200 exit,
            if ($apiResponse->getStatusCode() != Response::HTTP_OK) {
                $this->logger->warning("API responded with " .$apiResponse->getStatusCode(). " code");
                return null; //Or throw an exception instead (HttpException)
            }


            $content = $apiResponse->toArray();

            if (!$content["results"] || count($content["results"]) == 0){
                $this->logger->warning("No results returned from API");
                return null;
            }


            foreach ($content["results"] as $orderInfos) {

                if ($this->em->getRepository(Order::class)->find($orderInfos["OrderID"]))
                    break;

                $order = new Order();
                $order->setId($orderInfos["OrderID"])
                    ->setAmount($orderInfos["Amount"])
                    ->setCurrency($orderInfos["Currency"])
                    ->setOrderNumber($orderInfos["OrderNumber"]);

                // retrieve order contact
                $contact = $this->em->getRepository(Contact::class)->find($orderInfos["DeliverTo"]);
                // if not found in database check from api
                if (!$contact)
                    $contact = $this->searchContact($orderInfos["DeliverTo"]);
                $order->setDeliverTo($contact);

                $this->em->persist($order);

                // saving order items
                foreach ($orderInfos["SalesOrderLines"]["results"] as $salesOrderLine) {

                    $item = $this->em->getRepository(Item::class)->find($salesOrderLine["Item"]);
                    // if not found in database create new one
                    if (!$item) {
                        $item = new Item();
                        $item->setId($salesOrderLine["Item"])
                            ->setDescription($salesOrderLine["ItemDescription"]);
                        $this->em->persist($item);
                    }

                    $orderLine = new OrderLine();
                    $orderLine->setOrderr($order)
                        ->setItem($item)
                        ->setAmount($salesOrderLine["Amount"])
                        ->setDiscount($salesOrderLine["Discount"])
                        ->setDescription($salesOrderLine["Description"])
                        ->setQuantity($salesOrderLine["Quantity"])
                        ->setUnitCode($salesOrderLine["UnitCode"])
                        ->setUnitDescription($salesOrderLine["UnitDescription"])
                        ->setUnitPrice($salesOrderLine["UnitPrice"])
                        ->setVatAmount($salesOrderLine["VATAmount"])
                        ->setVatPercentage($salesOrderLine["VATPercentage"]);
                    $this->em->persist($orderLine);
                    // need to call addOrderLine because data in csv is not loaded from database
                    // see https://stackoverflow.com/questions/69544541/doctrine-need-to-call-set-or-add-in-many-to-one-relation
                    $order->addOrderLine($orderLine);
                }
                // save new order for csv export
                $newSavedOrder[] = $order;
            }
            $this->logger->info(count($newSavedOrder) . " new order(s) has been added to database");
            $this->em->flush();
            return $newSavedOrder;

        } catch (TransportExceptionInterface $e) {
            $this->logger->error('Failed to retrieve data from API: ' . $e->getMessage());
            throw new RuntimeException('Failed to retrieve data from API: ' . $e->getMessage());
        }

    }


    /**
     * Search contact from apy by id and save it
     * @throws ServerExceptionInterface
     * @throws RedirectionExceptionInterface
     * @throws DecodingExceptionInterface
     * @throws ClientExceptionInterface
     */
    public function searchContact(string $id): ?Contact
    {
        try {
            // get contacts response from api
            $this->logger->info("searching for contact with id: " . $id);
            $contactApiResponse = $this->client->request(
                Request::METHOD_GET,
                "{$this->container->getParameter('app.api_url')}/contacts",
                [
                    'headers' => [
                        'x-api-key' => $this->container->getParameter('app.api_key')
                    ]
                ]
            );

            // if response other than 200 exit,
            if ($contactApiResponse->getStatusCode() != Response::HTTP_OK){
                $this->logger->warning("API responded with " .$contactApiResponse->getStatusCode(). " code");
                return null; //Or throw an exception instead (HttpException)
            }

            $content = $contactApiResponse->toArray();

            if (!$content["results"] || count($content["results"]) == 0)
                return null;


            $contacts = $content["results"];
            // search for the order contact
            foreach ($contacts as $contact) {
                if ($id == $contact["ID"]){
                    $this->logger->info("Contact found.. persisting to database ");
                    $contact = (new Contact())
                        ->setAccountName($contact["AccountName"])
                        ->setAddressLine1($contact["AddressLine1"])
                        ->setAddressLine2($contact["AddressLine2"])
                        ->setCity($contact["City"])
                        ->setContactName($contact["ContactName"])
                        ->setCountry($contact["Country"])
                        ->setZipCode($contact["ZipCode"])
                        ->setId($contact["ID"]);
                    $this->em->persist($contact);
                    $this->em->flush();
                    return $contact;
                }
            }
            // return null if not found (todo: we may create an empty contact object if not found !)
            return null;

        } catch (TransportExceptionInterface $e) {
            $this->logger->error('Failed to retrieve contacts from API: ' . $e->getMessage());
            throw new RuntimeException('Failed to retrieve contacts from API: ' . $e->getMessage());
        }
    }

    /**
     * Generate and return a csv from an array of Orders
     * @param $orders
     * @return Response
     */
    public function generateCSV($orders): Response
    {
        $csvTab = [];
        /** @var Order $order */
        foreach ($orders as $order) {
            $itemIndex = 1;
            foreach ($order->getOrderLines() as $orderLine) {
                $contact = $order->getDeliverTo();
                $csvTab[] = [
                    $order->getOrderNumber(),
                    $contact->getContactName(),
                    $contact->getAddressLine1() . " - " . $contact->getAddressLine2(),
                    $contact->getCountry(),
                    $contact->getZipCode(),
                    $contact->getCity(),
                    $this->em->getRepository(OrderLine::class)->getOrderItemsCount($order),
                    $itemIndex,
                    $orderLine->getItem()->getId(),
                    $orderLine->getQuantity(),
                    $orderLine->getAmount(),
                    $orderLine->getAmount() + $orderLine->getVatAmount()
                ];
                $itemIndex++;
            }
        }
        // create csv file
        $fp = fopen('php://temp', 'w');
        // adding data
        foreach ($csvTab as $fields) {
            fputcsv($fp, $fields);
        }

        rewind($fp);
        $response = new Response(stream_get_contents($fp));
        fclose($fp);
        $response->headers->set('Content-Type', 'text/csv');
        $response->headers->set('Content-Disposition', 'attachment; filename="orders_'.time().'.csv"');

        return $response;
    }


}