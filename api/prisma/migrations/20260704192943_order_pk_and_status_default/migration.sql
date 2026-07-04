-- Redefine order_has_reference primary key: drop created_at from the key so a
-- reference appears at most once per order (one line with a quantity).
ALTER TABLE "order_has_reference" DROP CONSTRAINT "order_has_reference_pkey";
ALTER TABLE "order_has_reference" ADD CONSTRAINT "order_has_reference_pkey" PRIMARY KEY ("order_id", "reference_id");

-- Default status for newly created orders.
ALTER TABLE "order" ALTER COLUMN "status" SET DEFAULT 'New'::"enum_order_status";
