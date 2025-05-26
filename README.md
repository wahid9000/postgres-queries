# PostgreSQL-এ Primary Key এবং Foreign Key ব্যাখ্যা

## Primary Key কী?

**Primary Key** হলো এমন একটি কলাম বা কলামের কম্বিনেশন যা একটি টেবিলের প্রতিটি রেকর্ডকে ইউনিকলি সনাক্ত করে।  

প্রতিটি টেবিলে শুধুমাত্র **একটি Primary Key** থাকতে পারে এবং এই ফিল্ডের মান কখনো `NULL` হতে পারবে না এবং অবশ্যই ইউনিক হতে হবে।

### উদাহরণ:

```sql
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    age INT
);
```

এখানে `student_id` কলামটি Primary Key হিসেবে সেট করা হয়েছে, যা প্রতিটি স্টুডেন্টের জন্য ইউনিক আইডি তৈরি করবে।

---

## Foreign Key কী?

**Foreign Key** হলো এমন একটি কলাম বা কলামের সেট যা অন্য টেবিলের **Primary Key**-এর সাথে লিংক করে।  

এটি দুইটি টেবিলের মধ্যে সম্পর্ক (relation) তৈরি করতে ব্যবহৃত হয়। Foreign Key কলামটি সেই মানগুলোই গ্রহণ করবে যা parent টেবিলের Primary Key-তে বিদ্যমান।  

### উদাহরণ:

```sql
CREATE TABLE courses (
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT,
    course_id INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);
```

এখানে `enrollments` টেবিলের `student_id` এবং `course_id` কলামগুলো যথাক্রমে `students` এবং `courses` টেবিলের Primary Key-এর সাথে সম্পর্কিত।  

---

# PostgreSQL-এ VARCHAR এবং CHAR ডেটা টাইপের পার্থক্য

## VARCHAR কি?

**VARCHAR (Variable Character)** হলো একটি ডেটা টাইপ, যেখানে যত অক্ষর দেয়া হবে শুধু সেটুকু স্টোর করবে এবং অবশিষ্ট অংশের জন্য কোনো অতিরিক্ত স্পেস নষ্ট করবে না।  

### উদাহরণ:

```sql
CREATE TABLE employees (
    name VARCHAR(50)
);
```

এখানে `name` কলামে সর্বোচ্চ ৫০ অক্ষরের ভ্যালু রাখা যাবে। ৩০ অক্ষর দিলে ৩০-ই স্টোর হবে, বাকি ২০ এর জন্য স্পেস নষ্ট হবে না।

---

## CHAR কি?

**CHAR (Character)** হলো একটি Fixed-length ডেটা টাইপ যেখানে যদি কম অক্ষরের ভ্যালু দেয়া হয়, তাহলে অবশিষ্ট অংশ স্পেস (whitespace) দিয়ে পূরণ করবে।

### উদাহরণ:

```sql
CREATE TABLE products (
    product_code CHAR(10)
);
```

এখানে `product_code` কলামে ১০ অক্ষরের কম কিছু ইনসার্ট করলে অবশিষ্ট অংশ অটোমেটিক স্পেস দিয়ে পূরণ করবে।

---

# LIMIT এবং OFFSET কী জন্য ব্যবহৃত হয়?

SQL-এ `SELECT` স্টেটমেন্টের সাথে কাজ করার সময়, **LIMIT** এবং **OFFSET** ক্লজ ব্যবহার করা হয় একটি কোয়েরি থেকে কতগুলো রেকর্ড রিটার্ন হবে তা নিয়ন্ত্রণ করার জন্য।

- **LIMIT** ব্যবহার করা হয় কতগুলো রেকর্ড ফেরত আনবে তা নির্ধারণ করার জন্য।
- **OFFSET** ব্যবহার করা হয় নির্দিষ্ট সংখ্যক রেকর্ড স্কিপ করার জন্য, তারপর রেজাল্ট রিটার্ন শুরু করার আগে।

বড় ডেটাসেট নিয়ে কাজ করার সময় এবং অ্যাপ্লিকেশন-এ **pagination** (পেইজিং) ইমপ্লিমেন্ট করার ক্ষেত্রে এই ক্লজগুলো বিশেষভাবে দরকারি।

---

## সিনট্যাক্স

```sql
SELECT * FROM table_name
LIMIT number_of_rows
OFFSET number_of_rows_to_skip;
```

---

### উদাহরণ: ১

```sql
SELECT * FROM employees
LIMIT 2 OFFSET 2;
```

এই কোয়েরি প্রথম দুইটি রেকর্ড স্কিপ করে পরের দুইটি রেকর্ড রিটার্ন করবে।

---

### উদাহরণ: ২ (Pagination)

প্রথম পেইজের জন্য:

```sql
SELECT * FROM employees
ORDER BY employee_id
LIMIT 5 OFFSET (0 * 5);
```

এখানে `0` হচ্ছে `current_page` এবং `5` হচ্ছে প্রতি পেইজে দেখানোর রেকর্ড সংখ্যা।

---

দ্বিতীয় পেইজের জন্য:

```sql
SELECT * FROM employees
ORDER BY employee_id
LIMIT 5 OFFSET (1 * 5);
```

এখানে `1` হচ্ছে `current_page` এবং `5` হচ্ছে প্রতি পেইজে দেখানোর রেকর্ড সংখ্যা।

---

তৃতীয় পেইজের জন্য:

```sql
SELECT * FROM employees
ORDER BY employee_id
LIMIT 5 OFFSET (2 * 5);
```

এখানে `2` হচ্ছে `current_page` এবং `5` হচ্ছে প্রতি পেইজে দেখানোর রেকর্ড সংখ্যা।

---

## JOIN অপারেশনের গুরুত্ব এবং PostgreSQL-এ JOIN কিভাবে কাজ করে ?

`JOIN` অপারেশনটি ডেটাবেইসের একাধিক টেবিল থেকে সম্পর্কিত ডেটা একত্রে এনে বিশ্লেষণ করতে সাহায্য করে। প্রকৃতপক্ষে, অনেক ক্ষেত্রেই ডেটা আলাদা আলাদা টেবিলে রাখা হয় নর্মালাইজেশনের কারণে। তখন `JOIN` ব্যবহার করে আমরা প্রয়োজন অনুযায়ী সেই ডেটাগুলোকে যুক্ত করি।

PostgreSQL-এ বিভিন্ন ধরণের JOIN রয়েছে, যেমন:

### 1. `INNER JOIN`

দুইটি টেবিলের মধ্যে যেসব রেকর্ড মিলে যায় শুধু সেইগুলোই ফেরত দেয়।

```sql
SELECT *
FROM students
INNER JOIN courses ON students.course_id = courses.id;
```

### 2. `LEFT JOIN` বা `LEFT OUTER JOIN`

বাম পাশের টেবিলের সব রেকর্ড দেখায়, আর ডান পাশের টেবিলের সাথে যেগুলো মিলে যায় শুধু সেগুলো।

```sql
SELECT *
FROM students
LEFT JOIN courses ON students.course_id = courses.id;
```

### 3. `RIGHT JOIN` বা `RIGHT OUTER JOIN`

ডান পাশের টেবিলের সব রেকর্ড দেখায়, আর বাম পাশের সাথে যেগুলো মিলে যায় শুধু সেগুলো।

```sql
SELECT *
FROM students
RIGHT JOIN courses ON students.course_id = courses.id;
```

### 4. `FULL JOIN` বা `FULL OUTER JOIN`

দুই পাশের টেবিলের সব রেকর্ড দেখায়, মিল থাক বা না থাক।

```sql
SELECT *
FROM students
FULL JOIN courses ON students.course_id = courses.id;
```

---

## GROUP BY কী এবং GROUP BY ক্লজ এর গুরুত্ব ।

`GROUP BY` হলো SQL-এর একটি ক্লজ, যা টেবিলের ডেটাগুলো নির্দিষ্ট একটি বা একাধিক কলামের মান অনুযায়ী গ্রুপ করে। এটি সাধারণত **aggregation function** (যেমন: COUNT, SUM, AVG, MAX, MIN) এর সাথে ব্যবহার করা হয়।

`GROUP BY` ক্লজ SELECT স্টেটমেন্টে ব্যবহৃত হয়। এটি ডেটাকে নির্দিষ্ট কলামের ভিত্তিতে ভাগ করে এবং প্রতিটি গ্রুপের উপর Aggregation Function প্রয়োগ করে।

## উদাহরণ

ধরি আমাদের কাছে একটি `orders` টেবিল আছে:

| order_id | customer_name | amount |
|----------|----------------|--------|
| 1        | Wahid          | 500    |
| 2        | Zahid          | 200    |
| 3        | Wahid          | 300    |

### উদাহরণ : গ্রাহক অনুযায়ী মোট অর্ডারের পরিমাণ

```sql
SELECT customer_name, SUM(amount)
FROM orders
GROUP BY customer_name;
```

ফলাফল:

| customer_name | sum  |
|----------------|------|
| Wahid          | 800  |
| Zahid          | 200  |
