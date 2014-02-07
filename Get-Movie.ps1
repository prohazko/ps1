param(
 [string] $UserName = '<UserName>',
 [string] $Password = '<Password>'
)

function Download-Watchlist{
  Write-Host "Downloading fresh watchlist"
  
  $authParams = @{  
    login    = $UserName;
    password = $Password;
  }
  
  $ua = 'Mozilla/5.0 (Windows NT 6.3; WOW64; rv:26.0) Gecko/20100101 Firefox/26.0'
  $loginUrl = 'https://secure.imdb.com/register-imdb/login?ref_=nv_usr_lgin_3'
  
  Write-Host "auth ." -non
  
  $reqInit = Invoke-WebRequest -Uri $loginUrl -sessionVariable jar -userAgent $ua
  $fieldsEnum = $reqInit.Forms[1].Fields.GetEnumerator() ; 
  $fieldsEnum.MoveNext() | out-null
  $authParams.Add($fieldsEnum.Current.Key, $fieldsEnum.Current.Value) 
  
  Write-Host "."
  
  $global:reqAuth = Invoke-WebRequest -Uri $loginUrl -Method POST -Body $authParams -webSession $jar  -userAgent $ua
  
  $userLink = $reqAuth.Links | where href -match "http://www.imdb.com/user/*"  | select -first 1
  $userId  = $userLink.href -split '/' | where { $_.startsWith('ur') }  | select -first 1
  
  $watchlistUrl = "http://www.imdb.com/list/export?list_id=watchlist&author_id=$userId"
  $reqWatchlist = Invoke-WebRequest -Uri $watchlistUrl -webSession $jar -userAgent $ua
  
  [io.File]::writeAllText($watchlistFile, $reqWatchlist.Content)
  Write-Host "New watchlist saved to $watchlistFile"
}
  
$watchlistFile = Join-Path ([io.path]::GetTempPath()) 'watchlist.csv';

if(-not [io.file]::Exists($watchlistFile)){
  Download-Watchlist
}
$lastUpdateTime = (Get-Childitem $watchlistFile).lastwritetime
$lastUpdateDaysAgo = ((Get-Date) -  $lastUpdateTime).Days


if($lastUpdateDaysAgo -gt 0 ){
  Write-Host "Watchlist was updated $lastUpdateDaysAgo days ago [$lastUpdateTime]"
}
if($lastUpdateDaysAgo -gt 3 ){
  Download-Watchlist 
}

$movies = Import-Csv $watchlistFile

$moviesUnrated = $movies | ? { $_.'You rated' -eq '' }

$randomUnratedMovie = Get-Random $moviesUnrated


Write-Host "Movies total   : $($movies.Count)"
Write-Host "Movies rated   : $($movies.Count - $moviesUnrated.Count)"
Write-Host "Movies unrated : $($moviesUnrated.Count)"

Write-Host ( [environment]::newLine +   '*' * 40 )
Write-Host "$($randomUnratedMovie.Title) ($($randomUnratedMovie.Year)) [$($randomUnratedMovie.'IMDb Rating')]" -fore Green

Read-Host | out-null;

Start-Process $randomUnratedMovie.URL
