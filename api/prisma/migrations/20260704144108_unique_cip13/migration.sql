/*
  Warnings:

  - A unique constraint covering the columns `[cip13]` on the table `reference` will be added. If there are existing duplicate values, this will fail.

*/
-- CreateIndex
CREATE UNIQUE INDEX "reference_cip13_key" ON "reference"("cip13");
