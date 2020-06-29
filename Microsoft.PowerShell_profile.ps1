echo "DATE:" 
get-date

$uri ='http://feeds.feedburner.com/brainyquote/QUOTEBR'
$data = Invoke-RestMethod -Uri $uri 
$quote = "{0} - {1}" -f $data[0].description,$data[0].title
Write-host $quote -ForegroundColor yellow