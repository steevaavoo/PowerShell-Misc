#MOVE TO INDEPENDENT MODULE
# Connecting to Sharepoint
$orgName = 'advancedinsulationplc'
Connect-SPOService -Url https://$orgName-admin.sharepoint.com
#END MOVE TO INDEPENDENT MODULE

#BEGIN
# Getting the Site Groups in thebrain
$groups = Get-SPOSiteGroup -Site https://advancedinsulationplc.sharepoint.com/sites/thebrain
#END BEGIN

#PROCESS
foreach ($group in $groups) {
    # $members = $group.users
    # write-host "Group = $($group.LoginName), Members = $members"
    [PSCustomObject]@{
        'Group Name' = $group.LoginName
        'Members'    = $group.Users
    }
}
#END PROCESS

#END

#END END