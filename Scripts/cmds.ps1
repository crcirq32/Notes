﻿#Search for large files by length
Get-ChildItem c:\ -r| sort -descending -property length | select -first 10 name, Length