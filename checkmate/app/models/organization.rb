# rails generate model Organization org_id:integer org_name:string org_location:string parent_org_id:integer prebook_timeframe:float public_access:boolean org_pwd:string access_link:string
# rails g migration RemoveColumnNameOrganizations org_id:integer
# rails db:migrate

class Organization < ApplicationRecord
end
