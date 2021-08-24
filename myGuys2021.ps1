#Steps: 
#1. Get user ID from sleeper based on username https://api.sleeper.app/v1/user/<username>
#2. Get all drafts from 2021 season based on user id https://api.sleeper.app/v1/user/<user_id>/drafts/<sport>/<season>
#3. 

$userUri = "https://api.sleeper.app/v1/user/zachkleine"
$userObject = Invoke-RestMethod -uri $userUri
$userID = $userObject.user_id

$draftUri = "https://api.sleeper.app/v1/user/$userID/drafts/nfl/2021"
$draftObject = Invoke-RestMethod -uri $draftUri
$drafts = $draftObject.draft_id

foreach ($draft in $drafts)
{
    $allPicks = "https://api.sleeper.app/v1/draft/$draft/picks"
    $allPicksObject = Invoke-RestMethod -uri $allPicks
    $myPicks = $allPicksObject | Where-Object {$_.picked_by -eq $userID}
    $AllMyPicksObject += $myPicks
}

$trimMD = $AllMyPicksObject.metadata | Select-Object -Property position, first_name, last_name | Sort-Object -Property position, first_name, last_name

foreach ($player in $trimMD)
{
    $player.first_name += " "+$player.last_name
}
$combined = $trimMD | Select-Object -Property * -ExcludeProperty last_name
$nameList = $combined | Select-Object first_name | Get-Unique -AsString

foreach ($name in $nameList)
{
    if ($name -eq '')
    {
        $count ++
    }
}