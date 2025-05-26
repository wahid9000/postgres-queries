## 📌 LIMIT এবং OFFSET কী জন্য ব্যবহৃত হয়?

SQL-এ `SELECT` স্টেটমেন্টের সাথে কাজ করার সময়, **LIMIT** এবং **OFFSET** ক্লজ ব্যবহার করা হয় একটি কোয়েরি থেকে কতগুলো রেকর্ড রিটার্ন হবে তা নিয়ন্ত্রণ করার জন্য।

- **LIMIT** ব্যবহার করা হয় কতগুলো রেকর্ড ফেরত আনবে তা নির্ধারণ করার জন্য।
- **OFFSET** ব্যবহার করা হয় নির্দিষ্ট সংখ্যক রেকর্ড স্কিপ করার জন্য, তারপর রেজাল্ট রিটার্ন শুরু করার আগে।

বড় ডেটাসেট নিয়ে কাজ করার সময় এবং অ্যাপ্লিকেশন-এ **pagination** (পেইজিং) ইমপ্লিমেন্ট করার ক্ষেত্রে এই ক্লজগুলো বিশেষভাবে দরকারি।

---

## 📑 সিনট্যাক্স

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