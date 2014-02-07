$ui = $host.ui.rawUI
$prevBackColor = $ui.BackgroundColor
$prevForeColor = $ui.ForegroundColor
$ui.BackgroundColor = "black"
$ui.ForegroundColor = "green"

$n = [environment]::newLine    
try{
    Clear-Host
    Write-Host ($n * $ui.windowSize.height )
    Write-Host "Gob's Program: Y/N?" 
    Write-Host '? ' -noNewLine 

    $press = [console]::readKey() 

    if( -not ($press.keyChar -match 'y') ) {
        Exit
    }

    Write-Host $n
    $penusCount = 0
    for( ;;){
        Write-Host 'Penus ' -noNewLine 
        Start-Sleep -m  ( [int] ([math]::log($penusCount + 1) / 15)  ) 
        $penusCount++
        if($penusCount % 6 -eq 0 ) { Write-Host '' }
    }
}finally{
   Write-Host "$($n*3)  COME ON !  $($n*2)"
   $ui.BackgroundColor = $prevBackColor
   $ui.ForegroundColor = $prevForeColor
}
