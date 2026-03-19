-- ==========================================
-- 1. สร้าง Database และเลือกใช้งาน
-- ==========================================
CREATE DATABASE IF NOT EXISTS HIS_TEST;
USE HIS_TEST;

-- ==========================================
-- 2. สร้างโครงสร้างตาราง (DDL)
-- ==========================================

-- ตารางข้อมูลผู้ป่วย
CREATE TABLE Patient_Data (
    HN INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DOB DATE,
    District VARCHAR(50)
);

-- ตารางประวัติแพ้ยา (รองรับ UI: ประวัติแพ้ยาสีแดง)
CREATE TABLE Allergy_Record (
    Allergy_ID INT PRIMARY KEY AUTO_INCREMENT,
    HN INT,
    Drug_Name VARCHAR(100),
    Reaction VARCHAR(255),
    FOREIGN KEY (HN) REFERENCES Patient_Data(HN)
);

-- ตารางประวัติการเข้ารับบริการ
CREATE TABLE Visit_Log (
    VN INT PRIMARY KEY,
    HN INT,
    VisitDate DATE,
    Clinic_Name VARCHAR(100),
    FOREIGN KEY (HN) REFERENCES Patient_Data(HN)
);

-- ตารางบันทึกการตรวจทางคลินิก (รองรับ UI: บันทึกซ้าย-ขวา นศพ. และ อาจารย์)
CREATE TABLE Clinical_Note (
    Note_ID INT PRIMARY KEY AUTO_INCREMENT,
    VN INT,
    CC_PI TEXT,          -- ประวัติอาการ (เขียนโดย นศพ.)
    PE TEXT,             -- ผลตรวจร่างกาย (เขียนโดย นศพ.)
    Provisional_Dx TEXT, -- วินิจฉัยเบื้องต้น (เขียนโดย นศพ.)
    Attending_Note TEXT, -- ความเห็นเพิ่มเติม (เขียนโดย อาจารย์แพทย์)
    FOREIGN KEY (VN) REFERENCES Visit_Log(VN)
);

-- ตารางข้อมูลการวินิจฉัย
CREATE TABLE Diagnosis_Record (
    Diag_ID INT PRIMARY KEY AUTO_INCREMENT,
    VN INT,
    ICD10_Code VARCHAR(10),
    Attending_Doctor VARCHAR(100),
    Med_Student VARCHAR(100),
    FOREIGN KEY (VN) REFERENCES Visit_Log(VN)
);

-- ตารางคำสั่งจ่ายยา (รองรับ UI: Medication Order)
CREATE TABLE Medication_Order (
    Order_ID INT PRIMARY KEY AUTO_INCREMENT,
    VN INT,
    Drug_Name VARCHAR(100),
    Dosage_Instruction VARCHAR(255),
    FOREIGN KEY (VN) REFERENCES Visit_Log(VN)
);

-- ==========================================
-- 3. เพิ่มข้อมูลจำลอง (DML)
-- ==========================================

-- เพิ่มข้อมูลผู้ป่วย
INSERT INTO Patient_Data (HN, FirstName, LastName, DOB, District) VALUES
(123456, 'ใจดี', 'รักษาดี', '1971-05-15', 'เมืองกาฬสินธุ์'),
(987654, 'สมชาย', 'สายเสมอ', '1960-11-20', 'ยางตลาด');

-- เพิ่มประวัติแพ้ยา
INSERT INTO Allergy_Record (HN, Drug_Name, Reaction) VALUES
(123456, 'Penicillin', 'ผื่นคันรุนแรง หายใจติดขัด');

-- เพิ่มประวัติการเข้ามารับบริการ
INSERT INTO Visit_Log (VN, HN, VisitDate, Clinic_Name) VALUES
(26001, 123456, '2026-02-15', 'คลินิกอายุรกรรม'), -- ตรงเงื่อนไข
(26002, 987654, '2026-01-10', 'คลินิกศัลยกรรม'),  -- ไม่ตรงคลินิก
(26003, 123456, '2026-03-05', 'คลินิกอายุรกรรม'); -- ตรงเงื่อนไข

-- เพิ่มบันทึกการตรวจ 
INSERT INTO Clinical_Note (VN, CC_PI, PE, Provisional_Dx, Attending_Note) VALUES
(26001, 'อ่อนเพลีย ปัสสาวะบ่อย 2 สัปดาห์', 'BP 130/80, FBS 180', 'DM Type 2', 'เห็นด้วยกับ นศพ. เริ่มยาลดน้ำตาล');

-- เพิ่มการวินิจฉัย 
INSERT INTO Diagnosis_Record (VN, ICD10_Code, Attending_Doctor, Med_Student) VALUES
(26001, 'E11.9', 'อ.นพ. สมเกียรติ', 'นศพ. เรียนดี'), -- ตรงเงื่อนไข
(26002, 'K35.8', 'อ.พญ. สมศรี', 'นศพ. ขยัน'),    -- ไม่ใช่เบาหวาน
(26003, 'E11.2', 'อ.นพ. สมเกียรติ', 'นศพ. เรียนดี'); -- ตรงเงื่อนไข

-- เพิ่มคำสั่งจ่ายยา
INSERT INTO Medication_Order (VN, Drug_Name, Dosage_Instruction) VALUES
(26001, 'Metformin 500mg', '1 เม็ด หลังอาหาร เช้า-เย็น');