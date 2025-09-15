# CheckMate

## Team
| Name                           | Role            |
| ------------------------------ | --------------- |
| Ethan Ho                       | Product Manager |
| Mina Messad                    |                 |
| Allen Chacko Johny             |                 |
| Carlos Vanegas Hinojosa        |                 |
| Sarvani Yoganand Lakshmitulasi |                 |



# CheckMate User Stories 

CheckMate is an inventory and resource management platform for students, faculty, and student organizations at NJIT. It provides real-time visibility into item availability, streamlines check-in/check-out processes, and helps reduce shortages. It also supports event planning by allowing admins and student groups to reserve batches of tools in advance and receive reminders.

---

## 1. Admin (Faculty/Staff)
**Description:** Manages inventory, approves requests, monitors check-ins/outs, and ensures accountability for shared tools.  
**Personality:** Organized, responsible, detail-oriented.  
**Goals:**  
- Track borrowed items and overdue returns  
- Approve event/tool reservations  
- Generate usage analytics for planning future purchases  
**Problems / Pain Points:**  
- Managing multiple users and items can be overwhelming  
- Manual tracking can lead to errors  
- Need for quick oversight of inventory  

**Main Scenario Example:** Daily inventory and request management  
**Keypath:**  
1. Admin logs into CheckMate dashboard  
2. Dashboard shows:
   - Items due back today
   - Overdue items and flagged students
   - Incoming student requests
   - Pending event reservations requiring department approval  
3. Admin sends reminders for overdue items  
4. Admin checks and approves/denies event requests  
5. Admin exports usage data to plan for future purchases  

---

## 2. Student
**Description:** Borrows and returns tools, checks availability, and receives reminders.  
**Personality:** Tech-savvy, responsible, values convenience.  
**Goals:**  
- Easily borrow items and track due dates  
- Receive notifications for overdue items  
- Access bundled sets of tools for projects  
**Problems / Pain Points:**  
- Forgetting due dates  
- Difficulty tracking tool availability  
- Need for simplified checkout process  

**Main Scenario Example:** Borrow a soldering kit  
**Keypath:**  
1. Student logs into CheckMate (Makerspace station or mobile)  
2. Searches for the soldering kit  
3. System shows availability and due dates  
4. Student selects an available kit (bundled items included automatically)  
5. System logs checkout and sends due date reminder  
6. Student returns item; system updates inventory  
7. Overdue items flagged and admin notified  

---

## 3. Club Leader (Event Requests)
**Description:** Reserves multiple tools for student organization projects or events.  
**Personality:** Organized, collaborative, proactive.  
**Goals:**  
- Reserve multiple tools for events  
- Receive confirmations and reminders  
- Process bulk returns after events  
**Problems / Pain Points:**  
- Ensuring tools are available for events  
- Coordinating multiple members and checkouts  
- Avoiding lost or misplaced items  

**Main Scenario Example:** Event tool reservation  
**Keypath:**  
1. Club leader logs into CheckMate  
2. Selects tools needed for an event (e.g., calipers, precision measuring tools)  
3. Request routed to department head for approval (event priority)  
4. System reserves tools for the event date  
5. Leader and members receive confirmations and reminders  
6. After the event, leader processes bulk return of all items  

---

## Stakeholders at a Glance
- **Faculty/Staff (Admins):** Primary users managing inventory and event reservations  
- **Students:** Borrow tools and return them on time; rely on notifications  
- **Student Leaders:** Manage group reservations and bulk check-ins for events  

---

## Risks & Risk Management
**Risks:**  
- User data could be exposed → encrypt data in transit  
- Admins may accidentally see other organizations’ resources → implement role/group permissions  
- Unauthorized access could compromise emails and transactions → separate and anonymize sensitive data  

**Risk Management:**  
- Issues are categorized as High, Medium, or Low  
  - **High:** Critical availability/security issues → addressed within 1 week  
  - **Medium:** Not mission-critical, may affect users → addressed within 2 weeks  
  - **Low:** Minor issues affecting few users → addressed within 1 month  
- Issues assigned via task board and reviewed by Product Manager and developers  

