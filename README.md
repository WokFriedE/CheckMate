# CheckMate

## Team
Note: Team members may work on other sections when needed, below demonstrates primary roles
| Name                           | Primary Role            |
| ------------------------------ | ----------------------- |
| Ethan Ho                       | Product Manager         |
| Mina Messad                    | UI/UX Developer         |
| Allen Chacko Johny             | Data Architect          |
| Carlos Vanegas Hinojosa        | Microservices Developer |
| Sarvani Yoganand Lakshmitulasi | Quality & Dev Ops       |

## Terminology
### General Terms

| Term         | Definition                                                | Example                                       |
| ------------ | --------------------------------------------------------- | --------------------------------------------- |
| Organization | A logically separated shared pool of items and items.     | NJIT's Local ACM Chapter                      |
| Order        | A complete transaction of checking in and out an item.    | Laptop from ACM                               |
| Event        | A scheduled order that could typically is for bulk items. | Laptops, routers, and a 3D printer in 2 weeks |


### User Roles

| Role      | Description                                                                                                                                                                   |
| --------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Admin     | A developer or super user that has control of all the organizations of the application and setting managers.                                                                  |
| Manager   | A faculty / staff / student leader who is in control of the organization and its inventory. Has the power to handle organization settings and user roles in the organization. |
| Organizer | Another faculty / staff / student leader who will help control the inventory of an organization but has limit power.                                                          |
| User      | A student / staff / faculty who will use the app to check items in or out.                                                                                                    |


## Product Plan

### Far Vision

**FOR** students and faculty at NJIT including the student organizations, Makerspace, and departments

**WHO** need a reliable way to track borrows and returns for shared items like tools such as calipers, hammers, drills, and soldering kits, while keeping resources organized and avoiding lost or misplaced items

**CheckMate** is an inventory and resource management platform THAT provides real-time visibility into item availability, streamlines check-in/check-out processes, and helps reduce shortages by letting students know when items are due back. It also supports event planning by allowing admins and student groups to reserve batches of tools in advance and receive reminders.

**UNLIKE** simple spreadsheets or generic inventory trackers that only record items without context,

**OUR PRODUCT** offers real-time and easy inventory actions for students, staff, and faculty.  The product will contain automated notifications for overdue returns, batch reservations for classes or events, and a communication feature so students can confirm if they are still using a item. It also includes usage analytics, helping organizers or managers understand which items are most in demand and plan future purchases while also providing a seamless way to track their current inventory. Advanced features include restricted and self checkout modes (where either an authorized computer handles check-in/out or students can log in to do it themselves), and the ability to combine items into sets (e.g., one complete camera = body + lens). The inventory for an organization should be easy to maintain via the provided GUI and also import and export features for quick set ups. Essentially, our product will help guarantee seamless integration within current systems and help create easy experiences for students and faculty.

### Near Vision
The team wants to provide users of the application an easy and useful inventory system for checking in and out items. This will include features such as a login system to allow anyone utilize it, notifications for items, and check in and out system. For users, they should have their own dashboard to seen when items are overdue or to make order requests. For organizers, they should have a dashboard for managing their metrics, organizational checkout options on duration, approve and reject large orders, and overdue items. They should also have access to an inventory page for managing their items with updates, deletes, or additions. Managers should be able to add and modify user roles. Admins should be able to manage all organizations and create new ones. As a stretch feature and if time allots, it would be nice to implement a sub organization ability to allow for the management of a subset of items from an inventory. In reference to the product backlog, epics 1-7 will be required and epics 8 and 9 will be stretch goals, but hopefully will be completed.

Out of scope will be a direct messaging system between users and organizers.

### Backlog Tracker
https://github.com/users/WokFriedE/projects/7

### Product Backlog Items
Estimated PBI relative sizing was done with **T-Shirt sizing** which was interpreted into story points (XS=1, S=2, M=3, L=5, XL=8) and current S items, such as adding the ability to update an organizational setting, as a baseline.  

Below is the breakdown of the PBIs, currently they are ordered from top to bottom as most important to later issues. Most of the important items will become dependencies for later items, so they must be addressed first. Some PBI's are logically associated with an epic, but can be implemented later. These items will have a note in the additional notes. 
To further elaborate on the current order, authentication is required first as users will only be able to use the app logged in. The admin panel is important for generating organizations for later, as the database would need to be set appropriately. Though mock users can be set up later, but would be handy at the beginning. Next comes the manager panel for controlling users, though organizational config can be pushed for timing.
Afterwards, the inventory page and its operations are required as it sets up the main usage of the application. Therefore, afterwards, the checkout system is next as that is also a major part of the application. The user dashboard would be next for tracking items that are have been checked out and also to increase the QOL of checking out / in items. The organizer dashboard would then be set up as a complement to the user dashboard.
Lastly, the event request System and email systems will be last, acting as features we would like to add to make the app more flushed out and are based on all the previous items developed. Ideally 1-2 epics will be accomplished in one 2 week sprint, saving one sprint for buffer.

1. (epic) Authentication System
   1. Registration
      - Title: Authentication System
      - User Story: A student wants to register to the application.
      - Additional: Attempting to implement a SaaS for registration and login, so inherently same task for now; it would be nice to only have NJIT emails allowed
      - Story Points: 3
      - DOR:
        - User should be able to register to the application.
   2. Login
      - Title: Authentication System
      - User Story: A student wants to log in and log out of the application.
      - Additional: Attempting to implement a SaaS for registration and login, so inherently same task for now.
      - Story Points: 3
      - DOR:
        - User should be able to log in and enter the user dashboard page.
2. (epic) Admin Panel
   1. Create Organizations
      - Title: Create Organization
      - User Story: An admin can initiate creating a new organization with its initial members and dedicated database.
      - Story Points: 3
      - DOR:
        - Only allow an API endpoint which is simpler but makes it more difficult in the long run
   2. Mock Users
      - Title: Admin Mock User
      - User Story: Allow admin to mock a user view to address any issues that were reported and there should be ample logging.
      - Additional: This will be implemented later on in the project life cycle / stretch feature.
      - Story Points: 5
      - DOR:
        - There should be heavy logging on what occurs
        - Track who the logged in user is and also track who the imitated user is
        - Introduce limited power
3. (epic) Manager Panel
   1. Organization Configuration
      - Title: Organization Settings - Updates
      - User Story: A department head (manager) wants to change the display name, update their inventory information, or delete their organization.
      - Story Points: 2
      - DOR:
        - There is the ability for the manager to update the display name, current inventories, and delete the organization
   2. Manage User Roles
      - Title: Manage User Role
      - User Story: A department head (manager) should be able to make a colleague an organizer, allowing them to change their role and then save.
      - Story Points: 2
      - DOR:
        - Be able to see all the users in the organization / search people up.
        - Frontend should show a dropbox role for each person in the organization and change their roles.
   3. Invite Users
      - Title: Manager User Invites
      - User Story: A department head (manager) wants to invite a colleague to the organization as an organizer.
      - Story Points: 2
      - DOR:
        - A manager should be able to put in an email to invite the user to the organization.
        - This should be in the organization settings area and only available to organizers.
   4. Audit Log
      - Title: Manager Audit Log
      - User Story: A department head wants to see who recently changed the name of the organization.
      - Additional: We should set up a way to delete the data after x amount of time to not max out our database space.
      - Story Points: 2
      - DOR:
        - Set up an audit system that will track all organization changes
        - Add a sub process to each manager and organizer operation that would log what was done
4. (epic) Inventory Screen
   1. Create, Update, Delete Items
      - Title: Inventory Page - Item Handling
      - User Story: Staff (organizer) should be able to add and update their items and inventory quantities.
      - Story Points: 2
      - DOR:
        - CRUD operations should be set up in frontend and backend.
   2. Import Export
      - Title: Inventory Page - Import Export
      - User Story: Staff (organizer) should be able to import and export their inventory using CSV files.
      - Story Points: 2
      - DOR:
        - There should be an import that allows for CSVs to be used with item names and quantities.
        - The organizer should be able to export to CSV.
   3. Filter / Sort
      - Title: Inventory Page - Item Sorting/Filtering
      - User Story: The faculty member (organizer) wants to search and filter through their inventory to see how many of their pens remain.
      - Story Points: 2
      - DOR:
        - Set up a filter and sort system.
        - Add a search bar for fuzzy searching an item name or description.
    4. Item Page
      - Title: Inventory Item Page
      - User Story: Staff wants to see who currently has their pens and when they will be back.
      - Additional: Stretch
      - Story Points: 1
      - DOR: 
        - The person should be able to click on the item on the inventory page and see all current check outs 
        - Have a frontend page to see the current status of each item that is checked out and api endpoint to get details about an item.
5. (epic) User Check In / Out Page
   1. Self Check In
      - Title: Self-Checkout System
      - User Story: User can search an organization and choose items to check out (single checkout) or Student leader can bulk check out a bunch of items (multi checkout)
      - Story Points: 2
      - DOR: 
        - Create CRUD operations for orders (transaction) and allow a logged in user to search for an organization --> view a screen of the available items --> choose the items to check out --> store the results
   2. Self Check Out
      - Title: Self-checkout - Return
      - User Story: Student wants to return the item to the inventory that is marked as self checkout.
      - Story Points: 2
      - DOR: 
        - User would go to their dashboard --> click on the currently checked out item (can view checked in time, time till due, etc.)--> check out the item
        - User should also use the check in page (same path) to mark an item as returned
   3. Restricted Checkout 
      - Title: Restricted Mode
      - User Story: Staff only wants to allow one computer to checkout items when students take items out.
      - Story Points: 3
      - Additional: Focuses on having links for checkouts
      - DOR: 
        - Set a restricted password, utilize checkout link, use the password to unlock the inventory.
        - Users can check in or checkout using their UCID/user id per order. This should show up on their dashboard later.
        - Limit the amount of active sessions
   4. Password Protect Checkout
      - Title: Checkout Mode - Restricted Password
      - User Story: A faculty member only wants people with a specific password to check out items.
      - Story Points: 3
      - Additional: Just the password system
      - DOR: 
        - Allow the user to set a password to access the check in and checkout page.
        - Password should be stored as a hash (no plain text) and transferred in a secure format.
6. (epic) User Dashboard
   1. Quick View
      - Title: User Dashboard - Quick View
      - User Story: A student wants to see all their checked out items
      - Story Points: 2
      - DOR: 
        - There should be a card or info about all currently checked out items
        - Clicking would bring them to a punishments page (if overdue)
   2. User Dashboard - History
      - Title: User Dashboard - History
      - User Story: Student wants to view all their checked out items and when.
      - Story Points: 2
      - DOR: 
        - User should be able to see their order history via either a new page or on the dashboard
        - Backend needs to have an API to return a user's history
   3. Search Organization
      - Title: User Dashboard - Search Organization
      - User Story: A student wants to search up the Makerspace to request items for an event next week and also check the inventory.
      - Story Points: 2
      - DOR: 
        - Users should be able to fuzzy search for an organization name 
        - Users should be able to create an event request here 
        - Users should be able to create an order here
   4. Punishment Page / System
      - Title: Punishment Page
      - User Story: Student is severely overdue with returning a drill and owes a fine.
      - Story Points: 3
      - DOR: 
        - The user will be prompted to view the punishment page on log in when checking something out / quick view. It would show them the item that is out and the punishment.
        - Requires the order details to be updated with overdue message.
7. (epic) Organizer Dashboard
   1. Quick View
      - Title: Organizer Dashboard - Missing Items Quick View
      - User Story: A staff member (organizer) from the Makerspace wants to quickly see which items are currently out.
      - Story Points: 2
      - DOR:
        - Organizers should have a card that shows the most recently checked out items.
   2. History
      - Title: Organizer Dashboard - History
      - User Story: The staff (organizer) wants to see all the items taken out in the past month.
      - Story Points: 1
      - DOR:
        - The frontend dashboard should have a page for history or a card to let the organizer see when and who took it out.
        - Backend would need to return a GET request but like everything in organizer page, require role auth.
    3. Order Settings
      - Title: Order Settings
      - User Story: Staff (organizers) want to set the maximum time items can be taken out for, duration, and other items.
      - Story Points: 3
      - DOR:
        - Allow organizers to set settings for the organization for how orders can be made.
8.  (epic) Event Request System
    1.  Accept / Reject Event 
      - Title: Event System - Organizer Process Event
      - User Story: A staff member (organizer) wants to approve an event from a student, a week in advance, to take out a bunch of items.
      - Story Points: 2
      - DOR: 
        - The organizer should be able to approve or deny event requests on their dashboard.
        - The items should be marked as out of service for that due date and prevent future use.
    2.  Create Event
    - Title: Event System - Create Event
      - User Story: A student leader wants to request a bunch of materials for a future event next week. They search for the Makerspace and select the required items, date, and any other settings.
      - Story Points: 3
      - DOR: 
        - The request should be sent to an organizer.
        - User should be able to request an event from the organization search.
        - User should be able to set settings for the event in the request.
9.  (epic)Email Service 
    1.  Email users/organizer for overdue items
        - Title: Email Overdue Items
        - User Story: A student with an overdue soldering iron will be emailed, notifying them that they are late and directing them to the punishment page.
        - Story Points: 5
        - DOR: 
          -  Email the organizer and the user that an item is overdue with the punishment page.
    2.  Email user on invite
        - Title: Email User Invite
        - User Story: Staff gets added to organization and gets an email.
        - Story Points: 3
        - DOR: 
          - When a user is added they should get an email with a link to the organization dashboard
          - The email will also include some basic getting started information

## CheckMate User Stories 

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

--- 
# User Personas 
---

## Persona: Professor

* **Name:** Mark Smith  
* **Age:** 64  
* **Year:** N/A  
* **Major:** Applied Physics Ph.D.

**Background**  
Mark Smith is a snarky professor who teaches 3 classes a week for applied physics and runs 2 hands-on labs weekly. He prefers familiar, older technology and avoids complex new tools. Though he is interested in sharing physics knowledge and mentoring students and can grasp new concepts quickly but needs straightforward, simple design patterns. He struggles with advanced software systems or overly technical interfaces. He is reliant on his students to help him understand new technologies.  
**Goals**

* Help student clubs increase interest in physics  
* Ensure expensive lab and classroom equipment is safe  
* Keep lab stock organized and easy to track

**Pain Points**

* Dislikes complicated technology \- needs simplicity above all  
* Difficulty carrying items between labs  
* Limited access to university software and tools  
* Manages many students and classes simultaneously  
* Busy schedule with little time for tech learning  
* Misses communications due to overwhelming email volume  
* Unwilling to learn software with steep learning curves

**What They Want**

* A simple, easy-to-use application for tracking items loaned out for classes or clubs  
* Minimal setup and intuitive controls suitable for older, less tech-savvy users

**Scenario**: Getting Started

* **Long Description:** Smith wants a simple system to track his textbooks, lab tools, and equipment loaned to students with a quick start. He would also like the set up to include a way to restrict or limit access to the application with something like passwords.   
* **Traditional:** Keeps an Excel spreadsheet of all items and manually edits it when someone needs something, only through in person interactions or by email. This process becomes inefficient when he’s not in the office or buried in emails.  
* **Expected from App**: Smith wants to import his existing inventory easily. When it comes to securing his app he wants to restrict access with his class or any clubs with a password. Smith also needs a clean and simple interface for handling the inventory items.

**Story 1**  
As a professor, I want to import my old inventory sheets in under a minute so I can quickly onboard my 40 items.

* **Specific:** Import previous items from a CSV into current inventory  
* **Measurable:** Each item imports in ≤ 1.5 seconds  
* **Achievable:** Utilize CSV gem and template  
* **Relevant:** Key feature for onboarding  
* **Timeboxed:** Deliverable in 1 sprint (2 weeks)

**Story 2**  
As a professor, I want to set a password for item requests so that only my students and club members can access them.

* **Specific:** Set up a password for requests  
* **Measurable:** Only authorized users with the password can request items  
* **Achievable:** Use secure password libraries  
* **Relevant:** Prevents unauthorized access to important equipment  
* **Timeboxed:** Can be done in 7 days

**Story 3**  
As a less tech-savvy person, I want a clear, simple display of my items so I don’t get overwhelmed taking stock.

* **Specific:** Have a simple inventory screen  
* **Measurable:** Only show essential item info  
* **Achievable:** Focus on minimalist UI design patterns  
* **Relevant:** Keeps the interface simple and approachable  
* **Timeboxed:** UI is completable within 4 days 

**Scenario**: Handling Order Requests

* **Long Description:** Smith wants a system for professors to handle their requests seamlessly from students. Smith also wants to get the information through his email with a custom subject and be able to approve it or reject it quickly, in case a student needs it for a lab.  
* **Traditional:** The students would need to email the professor or find him directly to ask to take out items, and only when he checks can he finally give it out.  
* **Expected from App**:  Smith wants to be able to get an email to approve or deny student requests quickly and receive timely notifications.

**Story 1**  
As a professor, I want to approve or deny student requests as soon as I receive them so that I have full control of my inventory.

* **Specific:** Approve an order request  
* **Measurable:** All requests can be approved or denied as soon as it is in the system  
* **Achievable**: The request should be sent when it is ready in the service  
* **Relevant:** The professor wants control of requests   
* **Timeboxed**: Can be completed in half a sprint  (1 weeks)

**Story 2**  
As a professor, I should receive request notifications within 5 minutes so I don’t have to manually check the dashboard.

* **Specific:** Send notification for approval requests  
* **Measurable:** 100% of requests received within 5 minutes  
* **Achievable:** Use shared university email alert system  
* **Relevant:** Allows quick approvals  
* **Timeboxed:** Completable in a sprint with email system

**Story 3**  
As club professor, I want to be able to give club leaders higher limits so that they are not restricted like students for events.

* **Specific:** Implement a permission level for club leaders for an inventory  
* **Measurable:** Club leaders should be able to request more items than students   
* **Achievable:** Set up a role based permission system that takes role into consideration for quantity requests  
* **Relevant:** Club leaders should have different requests  
* **Timeboxed:** Should be completed by the end of the second development iteration and within one sprint (2 weeks)

---

##  Persona: Staff

* **Name:** Miranda Pecker  
* **Age:** 35  
* **Year:** N/A  
* **Major:** Higher Education and Student Affairs (MA)

**Background**  
Miranda Pecker controls the institute’s orientation and manages multiple aspects of the department. She likes to leverage software to make her work easier, values strong communication, and is a fast learner. Miranda has limited student workers and manages a large variety of moving parts including time sheets, documents, inventory items, and event planning.  
**Goals**

* Keep the department in check  
* Ensure there are no stolen items  
* Run events to help new students get accustomed to the university

**Pain Points**

* Does not like inefficient or unresponsive software  
* Large variety of items to track  
* Hard time keeping track of all moving parts and allocated resources  
* Difficulty managing student timesheets

**What They Want**

* A one-stop system that allows a variety of check-in and check-out options  
* Glanceable dashboards for documents, inventory, and event plans  
* Ability to assign and track tasks efficiently

**Scenario**: Separation of Access

* **Long Description:** Miranda has been working in Higher Education and Student Affairs for several years. She manages multiple moving parts including documents, time sheets, inventory items, and event planning. The current system is inefficient. A system that provides glanceable information and visibility into future plans will facilitate her workflow. She wants to ensure the inventory is properly separated so that students and her workers do not have the same level of access.  
* **Traditional**: If I wanted to separate the data, I would have to duplicate the data between different spreadsheets or manually inform people what they are in charge of.  
* **Expected from App**: Separate duties and responsibilities to make assigning and checking off tasks easier and hassle-free. Also, having role based access can help properly restrict who can access items that are being tracked.

**Story 1**  
As a director, I want role based permissions to restrict access so that students cannot view the organization's inventory.

* **Specific:** Restrict access to organization inventory and resources based on user roles  
* **Measurable:** Only individuals assigned with proper permissions can access the organization’s resources  
* **Achievable:** Implementing role-based access control ensures appropriate visibility  
* **Relevant:** Protecting inventory and resource information is essential for organizational privacy and security  
* **Timeboxed:** Must be completed by the first development iteration within one sprint (2 weeks)

**Story 2**  
As a director, I want to add any student workers to my team so that they can also handle the inventory.

* **Specific:** Add student workers to inventory management roles  
* **Measurable:** Assigned student workers can manage inventory tasks  
* **Achievable:** Allow for role assignment with role based access control  
* **Relevant:** Ensures workload is distributed and manageable  
* **Timeboxed:** To be completed within the first development iteration (2 weeks)

**Story 3**  
As an event planner, I want to view a clear, organized timeline of upcoming events, each with its own plans, notes, and assigned individuals so that I can efficiently manage and prepare for future activities.

* **Specific:** Create a dashboard that displays all upcoming events, with details such as tasks, notes, and participants  
* **Measurable:** The system should include a functional calendar view summarizing all scheduled events  
* **Achievable:** Implementing a calendar-based dashboard is feasible with existing tools  
* **Relevant:** Improves overall event coordination and resource management efficiency  
* **Timeboxed:** Should be completed within a sprint (2 weeks)

---

## Persona: Club Leader

* **Name:** Mary Graham  
* **Age:** 23  
* **Year:** Junior  
* **Major:** Mechanical Engineering

**Background:**  
Mary is president of the campus robotics club. She coordinates events and projects where members need access to shared equipment such as calipers, measurement tools, soldering kits, and other workshop items. She uses digital tools regularly for schoolwork and for organizing her club. She is responsible for managing equipment requests for competitions and workshops. Mary is a techy student but only considers herself average in skill. She is mostly adept at learning new technology, but there is a bit of a learning curve for her. She is enthusiastic about events and often has back to back events to run.  
**Goals:**

* Reserve and check out multiple items for upcoming club projects or events  
* Coordinate scheduling smoothly   
* Increase member retention and participation  
* Host larger club events 

**Pain Points:**

* Current checkout process is manual and requires paperwork  
* Hard to manage multiple requests at once  
* Difficult to get visibility on overdue returns  
* There are a lot mundane and repetitive tasks that could be automated

**What they want:**

* An online system that allows quick reservations and approvals  
* Ability to request multiple items for events with one submission  
* Notifications when items are overdue or available  
* Extensibility and modularity, so clubs with their own inventory can make it work

**Scenario:** Prepping For Club Event 

* **Long Description:** Mary leads a team of 15 students in her club. Before competitions, she must request tools in advance and coordinate who picks them up. She needs a streamlined process to reduce back-and-forth emails and paperwork.  
* **Traditional**: Fill paper forms, wait for faculty approval, track items manually  
* **Expected from App**: Submit a single request for multiple tools, see approval status, and track returns digitally

**Story 1:**  
As a club leader, I want to request multiple inventory items in a single reservation so that I can prepare for club events without submitting separate forms for each item.

* **Specific:** Multiple items in one request  
* **Measurable:** One approval covers all requested items  
* **Achievable:** Can be implemented with request bundling, and allow people to select multiple items  
* **Relevant:** Saves time for events  
* **Timeboxed:** Must be available before next semester

**Story 2:**   
As a club leader, I want to view the availability calendar for equipment so that I can plan events around item availability.

* **Specific:** Calendar view shows equipment reservations  
* **Measurable:** Conflicts are displayed visually  
* **Achievable:** Calendar integration can be added to the app  
* **Relevant:** Prevents scheduling conflicts  
* **Timeboxed:** Ready for first release of the system

**Story 3:**   
As a club leader, I want to duplicate past equipment requests so that I can easily prepare for recurring events without re-entering all the items.

* **Specific:** Past request details can be copied into a new request  
* **Measurable:** Reduces preparation time by reusing at least 80 percent of past event requests  
* **Achievable:** Database can store and reapply prior request templates  
* **Relevant:** Supports recurring events and competitions  
* **Timeboxed:** Must be finished before the annual robotics competition

**Story 4:**   
As a club leader, I want to receive notifications when requested items are approved or denied so that I can adjust my event plans quickly.

* **Specific:** Notifications are sent for each request status change  
* **Measurable:** 100 percent of requests trigger a notification  
* **Achievable:** System can use email or app alerts  
* **Relevant:** Keeps planning on track  
* **Timeboxed:** Implement before mid-term events

---

## Persona: Teaching Assistant

* **Name:** Arnold Shaw  
* **Age:** 23  
* **Year:** Second year  
* **Major:** Computer Science M.S.

**Background**  
Arnold Shaw is a highly involved teaching assistant who takes part in multiple campus events and clubs. He is well-known among both students and faculty and is very comfortable with technology. Arnold dislikes inefficiency and prefers tools that save time. Because he juggles several commitments, he needs applications that streamline his workflow and make management easy.  
**Goals**

* Help with project management  
* Work on multiple parallel matters with ease

**Pain Points**

* Needs quick response applications with easily accessible features  
* Requires flexibility when returning borrowed items due to a busy schedule

**What They Want**

* An application that can quickly and easily return items  
* Ability to manage various inventories and item statuses efficiently

**Scenario**: Multi-tasked Management of Inventory and Users

* **Long Description:** Arnold is involved in multiple organizations and wants to efficiently manage inventories across them. He wants a clear way to organize the items he has borrowed, view item statuses, and manage other users’ borrowed items for the organizations he oversees.  
* **Traditional:** Uses a physical log book that fills up quickly and takes too much time to maintain. Tracking dues and borrowed items manually is inefficient.  
* **Expected from App:** Arnold wants a single, centralized system to view, manage, and update inventory items for all organizations. The system should be fast, organized, and easy to navigate.

**Story 1**  
As a teaching assistant rushing to class, I want the system to process my item return in under 20 seconds so that I can use the remaining \~2 minutes to physically store the items.

* **Specific:** Process returns quickly  
* **Measurable:** ≤20 seconds to complete  
* **Achievable:** Reasonable system response time  
* **Relevant:** Helps TA return items efficiently  
* **Timeboxed:** Explicit 2-minute total constraint which should be completed in a sprint (2 weeks)

**Story 2**  
As I take part in multiple organizations' inventories, I want to filter my borrowed items by organization or event so I can quickly identify which items belong to which group.

* **Specific:** Filter by organization  
* **Measurable:** Items grouped/displayed by organization  
* **Achievable:** Straightforward query/filter feature  
* **Relevant:** Helps manage items across multiple events  
* **Timeboxed:** Whenever borrowed items are viewed \- can be completed in half a sprint (1 week)

**Story 3**  
As a TA, I want to generate an invite link or code within 1 minute of creating a new organization so that students can join immediately.

* **Specific:** Generate invite for an organization  
* **Measurable:** Invite created in ≤1 minute  
* **Achievable:** Basic system functionality  
* **Relevant:** Ensures quick onboarding of students  
* **Timeboxed:** Any time during the organization lifecycle, requires at most a sprint (2 weeks)

**Story 4**  
As a TA, I want to be assigned higher-level access above students’ access at all times so I can oversee and update the inventory when needed.

* **Specific:** Higher access than students  
* **Measurable:** Role permissions differentiated with TAs being able to do more in an organization  
* **Achievable:** Set up role based controls  
* **Relevant:** Helps TA manage inventory and users effectively  
* **Timeboxed:** Should take a sprint (2 weeks) to implement user roles

---

## Persona: Student

* **Name:** Emily Carter  
* **Age:** 20  
* **Year:** Sophomore  
* **Major:** Business Administration

**Background**  
Emily is an active student involved in multiple campus clubs as a volunteer, including the Yearbook club. She frequently needs access to equipment like cameras, SD cards, and other technical tools for events. Traditionally, Emily has to rely on paper sign-out sheets or coordinate with faculty, which often causes confusion and wasted time. She considers herself a little below average when it comes to understanding technology. Most of the time it is either fast and works or slow and broken.   
**Goals**

* Quickly find and reserve the equipment needed for club activities  
* Ensure that items are available when required  
* Avoid late returns or penalties  
* Be able to track previous check outs

**Pain Points**

* Paper-based systems are slow and prone to errors  
* Lack of transparency in equipment availability  
* Forgetting due dates leads to penalties or conflicts with faculty  
* Manual processes take time away from personal time

**What They Want**

* A digital solution to check equipment availability instantly  
* Easy reservation and checkout without paperwork  
* Automated reminders for returns  
* A personal borrowing history log

**Scenario**: Taking Out Equipment

* **Long Description:** Emily is preparing for a cultural club event and needs to take out camera equipment to take pictures for the event.   
* **Traditional:** She would rely on paper forms and memory for signing out items, often leading to last-minute issues or conflicts of other people also needing the cameras or SD cards.  
* **Expected from App:** Emily can instantly see what’s available, reserve the items, and receive return reminders, making the process smoother and stress-free.

**Story 1**  
As a student, I want to search for available equipment that takes less than 5 seconds to show results so that I can quickly find what I need for club activities.

* **Specific:** Search for equipment   
* **Measurable:** There should be a search bar to look up items within 5 seconds   
* **Achievable:** Search results should be able to look up the items of an organization and display them  
* **Relevant:** Allows Emily to find stuff in large inventories   
* **Timeboxed:** Should take half a sprint (1 week) 

**Story 2**  
As a student, I want to check out items through the website and take less than a minute to process so that I don’t need to fill out manual forms.

* **Specific:** Emily should be able to check out items  
* **Measurable:** A student can check out an item in less than a minute  
* **Achievable:** The system should log the transaction, update the inventory, and provide an update  
* **Relevant:** Students should be able to interact with checking out   
* **Timeboxed:** Should be completed in a sprint (2 weeks)

**Story 3**  
As a student, I want to receive return reminders at least a day before it's due so that I avoid penalties or issues.

* **Specific:** Receive a return reminder   
* **Measurable:** Trigger notifications 95% of the time and one time   
* **Achievable:** The system can calculate due dates and sends reminders when it needs to  
* **Relevant:** Allows students to return items on time  
* **Timeboxed:** Should be completed in a sprint (2 weeks)

**Story 4**  
As a student, I want to track my borrowing history so that I know which items I have used and when they were returned.

* **Specific:** Look at the borrow history  
* **Measurable:** History should show the past 12 months of items   
* **Achievable:** System should store check outs for users  
* **Relevant:** Helps students track borrows and help with disputes  
* **Timeboxed:** Should be completed in half a sprint (1 weeks)
