/*
  Migration: updateOrderStripe

  เพิ่มข้อมูล Stripe ลงใน Order
  โดยเก็บข้อมูล Order เก่าที่มีอยู่ไว้
*/

-- ============================================
-- 1. เพิ่ม Column ใหม่ โดยอนุญาต NULL ชั่วคราว
-- ============================================

ALTER TABLE `order`
    ADD COLUMN `amount` INTEGER NULL,
    ADD COLUMN `currentcy` VARCHAR(191) NULL,
    ADD COLUMN `status` VARCHAR(191) NULL,
    ADD COLUMN `stripePaymentId` VARCHAR(191) NULL;


-- ============================================
-- 2. กำหนดค่าให้ Order เก่าที่มีอยู่แล้ว
-- ============================================

UPDATE `order`
SET
    `amount` = 0,
    `currentcy` = 'thb',
    `status` = 'legacy',
    `stripePaymentId` = CONCAT('legacy_', `id`)
WHERE `amount` IS NULL;


-- ============================================
-- 3. เมื่อข้อมูลเก่ามีค่าครบแล้ว
--    เปลี่ยนกลับเป็น NOT NULL ให้ตรง Prisma Schema
-- ============================================

ALTER TABLE `order`
    MODIFY `amount` INTEGER NOT NULL,
    MODIFY `currentcy` VARCHAR(191) NOT NULL,
    MODIFY `status` VARCHAR(191) NOT NULL,
    MODIFY `stripePaymentId` VARCHAR(191) NOT NULL;