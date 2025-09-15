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

## Product Plan

### Backlog Tracker
https://github.com/users/WokFriedE/projects/7

### Far Vision

**FOR** students and faculty at NJIT including the student organizations, Makerspace, and departments

**WHO** need a reliable way to track borrows and returns for shared items like tools such as calipers, hammers, drills, and soldering kits, while keeping resources organized and avoiding lost or misplaced items

**CheckMate** is an inventory and resource management platform THAT provides real-time visibility into item availability, streamlines check-in/check-out processes, and helps reduce shortages by letting students know when items are due back. It also supports event planning by allowing admins and student groups to reserve batches of tools in advance and receive reminders.

**UNLIKE** simple spreadsheets or generic inventory trackers that only record items without context,

**OUR PRODUCT** offers real-time and easy inventory actions for students, staff, and faculty.  The product will contain automated notifications for overdue returns, batch reservations for classes or events, and a communication feature so students can confirm if they are still using a item. It also includes usage analytics, helping organizers or managers understand which items are most in demand and plan future purchases while also providing a seamless way to track their current inventory. Advanced features include restricted and self checkout modes (where either an authorized computer handles check-in/out or students can log in to do it themselves), and the ability to combine items into sets (e.g., one complete camera = body + lens). The inventory for an organization should be easy to maintain via the provided GUI and also import and export features for quick set ups. Essentially, our product will help guarantee seamless integration within current systems and help create easy experiences for students and faculty.

### Near Vision
The team wants to provide users of the application an easy and useful inventory system for checking in and out items. This will include features such as a login system to allow anyone utilize it, notifications for items, and check in and out system. For users, they should have their own dashboard to seen when items are overdue or to make order requests. For organizers, they should have a dashboard for managing their metrics, organizational checkout options on duration, approve and reject large orders, and overdue items. They should also have access to an inventory page for managing their items with updates, deletes, or additions. Managers should be able to add and modify user roles. Admins should be able to manage all organizations and create new ones. As a stretch feature and if time allots, it would be nice to implement a sub organization ability to allow for the management of a subset of items from an inventory.

Out of scope will be a direct messaging system between users and organizers for 

### Product Backlog Items
Estimated PBI relative sizing was done with T-Shirt sizing which was interpreted into story points (XS=1, S=2, M=3, L=5, XL=8) and current S items, such as adding the ability to update an organizational setting, as a baseline.  

1. (epic) Authentication System
   1. Registration
      - Title: Authentication System
      - User Story: A student wants to register to the application.
      - Additional: Attempting to implement a SaaS for registration and login
      - Story Points: 3
   2. Login
      - Title: Authentication System
      - User Story: A student wants to log in and log out of the application.
      - Additional: Attempting to implement a SaaS for registration and login
      - Story Points: 3
2. (epic) Admin Panel
   1. Create Organizations
      - Title: Create Organization
      - User Story: An admin can initiate creating a new organization with its initial members and dedicated database.
      - Story Points: 3
   2. Mock Users
      - Title: Admin Mock User
      - User Story: Allow admin to mock a user view to address any issues that were reported and there should be ample logging.
      - Additional: This will be implemented later on in the project life cycle / stretch feature.
      - Story Points: 5
3. (epic) Manager Panel
   1. Organization Configuration
      - Title: Organization Settings - Updates
      - User Story: A department head (manager) wants to change the display name, update their inventory information, or delete their organization.
      - Story Points: 2
   2. Manage User Roles
      - Title: Manage User Role
      - User Story: A department head (manager) should be able to make a colleague an organizer, allowing them to change their role and then save.
      - Story Points: 2
   3. Invite Roles
      - Title: Manager User Invites
      - User Story: A department head (manager) wants to invite a colleague to the organization as an organizer.
      - Story Points: 2
4. (epic) Organizer Dashboard
   1. 
5. (epic) Inventory Screen
   1. 
6. (epic) User Dashboard
   1. 
7. (epic) User Check In / Out Page
   1. 
8. (epic) Audit Log
   1. 
9.  (epic) Event Request System
    1.  
10. (epic)Email Service 
    1.  Email users for overdue items