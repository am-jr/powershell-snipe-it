function Find-SnipeModel {
    <#
        .SYNOPSIS
            This function pulls all Models currently available on Snipe-IT.
        .DESCRIPTION
           Currently this function does not allow for searching of any kind, nor does it account for results greater than 500.
        .EXAMPLE
            Find-SnipeModel -url $url -SnipeApiKey $SnipeApiKey
        .LINK
            https://snipe-it.readme.io/reference/models
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [securestring]$SnipeApiKey,
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true)]
        [string]$url
    )

    $headers = @{
        'Accept'        = 'application/json'
        'Authorization' = "Bearer $([Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SnipeApiKey)))"
    }

    $restArgs = @{
        'Uri'     = "$url/api/v1/models?"
        'Headers' = $headers
        'Method'  = 'GET'
    }

    $response = Invoke-RestMethod @restArgs

    Return $response.rows
}