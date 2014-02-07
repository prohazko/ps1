$ui = $host.ui.rawUI
$prevBackColor = $ui.BackgroundColor
$prevForeColor = $ui.ForegroundColor
$ui.BackgroundColor = "black"
$ui.ForegroundColor = "green"
    
try{
    Clear-Host
    Write-Host ("`n" * $ui.windowSize.height )
    Write-Host "Gob's Program: Y/N?" 
    Write-Host '? ' -non 

    $press = [console]::readKey() 

    if( -not ($press.keyChar -match 'y') ) {
        Write-Host "`n`n`n COME ON !"
        Exit
    }

    Write-Host "`n"
    $penusCount = 0
    for( ;;){
        Write-Host "Penus " -noNewLine 
        Start-Sleep -m  ( [int] ([math]::log($penusCount + 1) / 15)  ) 
        $penusCount++
        if($penusCount % 6 -eq 0 ) { Write-Host '' }
    }
}finally{
   Write-Host "`n"
   $ui.BackgroundColor = $prevBackColor
   $ui.ForegroundColor = $prevForeColor
}
