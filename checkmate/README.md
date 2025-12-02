# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
set up rbenv 
- rbenv install 3.4.5

* System dependencies

* Configuration
ERB LSP - https://marketplace.visualstudio.com/items?itemName=aliariff.vscode-erb-beautify 
Set the exec path to: `/home/{user_name}/.rbenv/versions/3.4.5/bin/htmlbeautifier` with ubuntu
Set the bundle path to: `/home/{user_name}/github/CheckMate/checkmate/bin/bundle` with ubuntu

* Database creation
Example:
Manual example
- rails generate model Organization org_id:integer org_name:string org_location:string parent_org_id:integer prebook_timeframe:float public_access:boolean org_pwd:string access_link:string
Specific sql
- rails g migration RemoveColumnNameOrganizations org_id:integer
- rails db:migrate
- bin/rails db:rollback STEP=1
- bin/rails db:migrate

Create model, controller, view dir
- rails generate resource Organization org_id:integer org_name:string org_location:string parent_org_id:integer prebook_timeframe:float public_access:boolean org_pwd:string access_link:string
- rails db:migrate

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
