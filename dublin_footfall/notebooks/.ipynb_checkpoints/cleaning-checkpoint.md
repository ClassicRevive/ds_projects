# Cleaning in OpenRefine

1. Blanks in Count column.
I converted count to an integer column, used the numeric 
facet option to find all the blanks, star these rows and delete them.

2. Multiple naming standards for the same location. eg. O'Connell St, Parnell St @ AIB, OConnell St Parnell St at AIB
I faceted by text to reveal these and first used fingerprint clustering to merge some of the names. I then made some manual changes.

Errors:

O'Connell St Outside Clerys(8754 rows)
OConnell St Outside Clerys(7294 rows)
**merged to**: O'Connell St Outside Clerys

Grafton Street / Nassau Street / Suffolk Street(29547 rows)
Grafton Street - Nassau Street - Suffolk Street(7295 rows)
**merged to**: Grafton Street / Nassau Street / Suffolk Street

College Green, Bank Of Ireland(29547 rows)
College Green Bank Of Ireland(6767 rows)
**merged to**:College Green, Bank Of Ireland

O'Connell St Outside Pennys(35019 rows)
OConnell St Outside Pennys(7294 rows)
**merged to**:O'Connell St Outside Pennys

Doilier Street, Burgh Quay(29535 rows)
Doilier Street Burgh Quay(7295 rows)
**merged to**: Doilier Street, Burgh Quay

Grafton Street @ CompuB
**changed** "@" to "at" manually

OConnel St Parnell St at AIB
O'Connel St Parnell St @ AIB
**changed to**: O'Connel St Parnell St at AIB

I then exported the cleaned data as csv and returned to the notebook.