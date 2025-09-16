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
The team wants to provide users of the application an easy and useful inventory system for checking in and out items. This will include features such as a login system to allow anyone utilize it, notifications for items, and check in and out system. For users, they should have their own dashboard to seen when items are overdue or to make order requests. For organizers, they should have a dashboard for managing their metrics, organizational checkout options on duration, approve and reject large orders, and overdue items. They should also have access to an inventory page for managing their items with updates, deletes, or additions. Managers should be able to add and modify user roles. Admins should be able to manage all organizations and create new ones. As a stretch feature and if time allots, it would be nice to implement a sub organization ability to allow for the management of a subset of items from an inventory.

Out of scope will be a direct messaging system between users and organizers for 

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
