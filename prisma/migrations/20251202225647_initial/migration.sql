-- CreateEnum
CREATE TYPE "SystemCultureMode" AS ENUM ('RICE_WHITE', 'RICE_PARBO');

-- CreateTable
CREATE TABLE "Company" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "name" TEXT NOT NULL,
    "timezone" TEXT NOT NULL,
    "country" TEXT NOT NULL,
    "state" TEXT NOT NULL,
    "city" TEXT NOT NULL,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "TraceabilityTrackingOptions" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "SystemCultureMode" "SystemCultureMode" NOT NULL DEFAULT 'RICE_WHITE',
    "companyId" TEXT NOT NULL,

    CONSTRAINT "TraceabilityTrackingOptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Producer" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "name" TEXT NOT NULL,
    "search_name" TEXT NOT NULL,
    "companyId" TEXT NOT NULL,

    CONSTRAINT "Producer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_ProducerToTraceabilityTrackingOptions" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,

    CONSTRAINT "_ProducerToTraceabilityTrackingOptions_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE INDEX "TraceabilityTrackingOptions_createdAt_idx" ON "TraceabilityTrackingOptions"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "TraceabilityTrackingOptions_SystemCultureMode_companyId_key" ON "TraceabilityTrackingOptions"("SystemCultureMode", "companyId");

-- CreateIndex
CREATE INDEX "Producer_createdAt_idx" ON "Producer"("createdAt");

-- CreateIndex
CREATE INDEX "_ProducerToTraceabilityTrackingOptions_B_index" ON "_ProducerToTraceabilityTrackingOptions"("B");

-- AddForeignKey
ALTER TABLE "TraceabilityTrackingOptions" ADD CONSTRAINT "TraceabilityTrackingOptions_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Producer" ADD CONSTRAINT "Producer_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ProducerToTraceabilityTrackingOptions" ADD CONSTRAINT "_ProducerToTraceabilityTrackingOptions_A_fkey" FOREIGN KEY ("A") REFERENCES "Producer"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ProducerToTraceabilityTrackingOptions" ADD CONSTRAINT "_ProducerToTraceabilityTrackingOptions_B_fkey" FOREIGN KEY ("B") REFERENCES "TraceabilityTrackingOptions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
