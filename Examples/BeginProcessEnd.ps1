function PipelineTest {
    [cmdletbinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int]$number
    )
    Begin {
        Write-Host "Begin block"
    }

    Process {
        Write-Host "Process block for $number"
    }

    End {

        Write-Host "End block"
    }
}

1..10 | PipelineTest

