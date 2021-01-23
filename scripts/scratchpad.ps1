
Get-DkimSigningConfig -Identity domain.co.uk | Format-List

New-DkimSigningConfig -DomainName domain.co.uk -Enabled $false

Get-DkimSigningConfig -Identity domain.co.uk | Format-List Selector1CNAME, Selector2CNAME

# One already exists - this is pointless.
New-DkimSigningConfig -DomainName domain.co.uk -KeySize 2048 -Enabled $False


# domainGUID
domain-co-uk

# Initial Domain
domaincouk.onmicrosoft.com

_dmarc.domain.co.uk  3600  IN  TXT  "v=DMARC1; p=none; pct=100"


