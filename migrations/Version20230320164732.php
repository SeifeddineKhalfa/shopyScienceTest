<?php

declare(strict_types=1);

namespace DoctrineMigrations;

use Doctrine\DBAL\Schema\Schema;
use Doctrine\Migrations\AbstractMigration;

/**
 * Auto-generated Migration: Please modify to your needs!
 */
final class Version20230320164732 extends AbstractMigration
{
    public function getDescription(): string
    {
        return '';
    }

    public function up(Schema $schema): void
    {
        // this up() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE order_line ADD orderr_id VARCHAR(255) NOT NULL');
        $this->addSql('ALTER TABLE order_line ADD CONSTRAINT FK_9CE58EE17742FDB3 FOREIGN KEY (orderr_id) REFERENCES `order` (id)');
        $this->addSql('CREATE INDEX IDX_9CE58EE17742FDB3 ON order_line (orderr_id)');
    }

    public function down(Schema $schema): void
    {
        // this down() migration is auto-generated, please modify it to your needs
        $this->addSql('ALTER TABLE order_line DROP FOREIGN KEY FK_9CE58EE17742FDB3');
        $this->addSql('DROP INDEX IDX_9CE58EE17742FDB3 ON order_line');
        $this->addSql('ALTER TABLE order_line DROP orderr_id');
    }
}
