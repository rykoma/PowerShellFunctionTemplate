# See also

# About Functions Advanced Parameters
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-6

# About Functions CmdletBindingAttribute
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_cmdletbindingattribute?view=powershell-6

function PowerShellFunctionTemplate {
    [CmdletBinding(
        DefaultParameterSetName = "Set1",
        SupportsShouldProcess = $true,
        ConfirmImpact = "High"
    )]

    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "Set1" )]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "Set2" )]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "Set3" )]
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ParameterSetName = "Set4" )]
        [ValidateLength(0,10)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Arg1,

        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $false, ParameterSetName = "Set1" )]
        [bool]
        $Arg2 = $true,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $false, ParameterSetName = "Set2" )]
        [string]
        $Arg3,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $false, ParameterSetName = "Set3" )]
        [switch]
        $Arg4,

        [Parameter(Mandatory = $true, Position = 1, ValueFromPipeline = $false, ParameterSetName = "Set4" )]
        [ValidateRange(1,10)]
        [ValidateScript( { $_ % 2 -eq 0 } ) ]
        [int]
        $Arg5,

        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $false, ParameterSetName = "Set1" )]
        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $false, ParameterSetName = "Set2" )]
        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $false, ParameterSetName = "Set3" )]
        [Parameter(Mandatory = $false, Position = 2, ValueFromPipeline = $false, ParameterSetName = "Set4" )]
        [ValidateCount(1,2)]
        [ValidateSet("Val1", "Val2", "Val3")]
        [string[]]
        $Arg6 = @("Val1", "Val2")
    )

    Begin
    {
        $LogFilePath = "C:\temp\PowerShellFunctionTemplate.log" # Log file name

        ### Internal Function
        function Write-DebugLog {
            param(
                [int]$Level,
                [string]$Log,
                [string[]]$Arg
            )
    
            if ($null -ne $Arg) {
                for ($i = 0; $i -lt $Arg.Length; $i++) {
                    $Log = $Log.Replace("{" + $i.ToString() + "}", $Arg[$i].ToString())
                }
            }
    
            $Log = "[" + [DateTime]::UtcNow.ToString("o") + "] " + $Log.PadLeft($Log.Length + $Level * 2)
            $Log | Out-File $LogFilePath -Encoding UTF8 -Append

            if ($WriteVerbose) {
                Write-Verbose $Log
            }
        }

        function Setup
        {
            Write-DebugLog -Level 1 -Log "Setup"
            Set-Variable -Name SetupDone -Value $true -Scope 1
        }

        $WriteVerbose = $PSCmdlet.MyInvocation.BoundParameters.ContainsKey("Verbose")
        
        Write-DebugLog -Level 0 -Log "Start"
        Write-DebugLog -Level 1 -Log "ParameterSetName : {1}" -Arg $PSCmdlet.ParameterSetName

        Setup
    }

    Process
    {
        if (-not $SetupDone) { Setup }

        if ($PSCmdlet.ShouldProcess($Arg1, "Do somothing")) {
            Write-DebugLog -Level 1 -Log "{0} : {1}" -Arg $Arg1, "Done"
        }
    }

    End {
        Write-DebugLog -Level 0 -Log "End"
    }
}