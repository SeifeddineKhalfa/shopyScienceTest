<?php

namespace App\Controller;

use App\Repository\OrderRepository;
use App\Service\OrderService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Serializer\Serializer;
use Symfony\Component\Serializer\SerializerInterface;

/**
 * @Route("/flow")
 */
class OrderController extends AbstractController
{

    /**
     * retrieve new corders from api
     * save orders, items and orderlines
     * return csv with new orders
     * @Route("/order_to_csv", name="flow_order_to_csv")
     */
    public function flowToCSV(OrderService $orderService): Response
    {
        $newSavedOrders = $orderService->retrieveOrders();

        return $orderService->generateCSV($newSavedOrders);
    }


    /**
     * @Route("/orders", name="orders_list")
     * @param OrderRepository $orderRepository
     * @param Serializer $serializer
     * @return Response
     */
    public function showOrders(OrderRepository $orderRepository, SerializerInterface $serializer): Response
    {
        /** for json response we can use SerializerInterface */
        /*$serializedOrders = $serializer->serialize($orderRepository->findAll(), 'json');
        $response = new JsonResponse();
        $response->setContent($serializedOrders);
        $response->headers->set('Content-Type', 'application/json');
        return $response;*/

        // simple listing
        return $this->render("order/list.html.twig", [
            "orders" => $orderRepository->findAll()
        ]);
    }
}