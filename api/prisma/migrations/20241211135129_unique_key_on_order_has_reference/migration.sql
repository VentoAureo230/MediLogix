/*
  Warnings:

  - The primary key for the `order_has_reference` table will be changed. If it partially fails, the table could be left without primary key constraint.

*/
-- AlterTable
ALTER TABLE "order_has_reference" DROP CONSTRAINT "order_has_reference_pkey",
ADD CONSTRAINT "order_has_reference_pkey" PRIMARY KEY ("order_id", "reference_id", "created_at");
