## SQL - Data Cleaning - NashvilleHousingData

Table below shows the distinction between the features in both .xlsx files. All data here are cleaned using SQL Server Management Studio 18

| Raw Dataset Features | Cleaned Dataset Features |
| :--- | :--- |
| UniqueID | UniqueID |
| ParcelID | ParcelID |
| LandUse | LandUse |
| **PropertyAddress** | SalePrice |
| **SaleDate** | LegalReference |
| SalePrice | SoldAsVacant |
| LegalReference | OwnerName |
| SoldAsVacant | Acreage |
| OwnerName | LandValue |
| **OwnerAddress** | BuildingValue |
| Acreage | TotalValue |
| **TaxDistrict** | YearBuilt |
| LandValue | Bedrooms |
| BuildingValue | FullBath |
| TotalValue | HalfBath |
| YearBuilt | SaleDateConverted |
| Bedrooms | PropertySplitAddress |
| FullBath | PropertySplitCity |
| HalfBath | OwnerSplitAddress |
| - | OwnerSplitCity |
| - | OwnerSplitState |
* **Bold** indicates what was removed from RAW to CLEANED dataset*

### Requirements: 
- [Download SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver15)
- [Download SQL Server Express](https://www.microsoft.com/en-us/sql-server/sql-server-downloads) 
