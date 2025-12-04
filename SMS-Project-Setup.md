# School Management System (SMS) - .NET Core Web Application
## Complete Installation & Setup Guide

### Project Overview
A comprehensive School Management System built with:
- **Framework**: .NET Core 8.0
- **IDE**: Visual Studio 2026
- **Database**: SQL Server 2022+
- **ORM**: Entity Framework Core
- **Frontend**: ASP.NET Core Razor Pages + Bootstrap 5
- **Authentication**: Role-Based Access Control (RBAC)

---

## Project Structure

```
SchoolManagementSystem/
├── SchoolManagementSystem.Web/          # Main Web Application
│   ├── Controllers/                     # API & MVC Controllers
│   ├── Models/                          # Entity Models
│   ├── Services/                        # Business Logic
│   ├── Data/                            # DbContext & Migrations
│   ├── Views/                           # Razor Pages
│   ├── wwwroot/                         # Static Files (CSS, JS, Images)
│   ├── appsettings.json                 # Configuration
│   └── Program.cs                       # Startup Configuration
├── SchoolManagementSystem.Infrastructure/  # Data Access Layer
│   ├── Data/
│   └── Repositories/
├── SchoolManagementSystem.Core/         # Business Logic Layer
│   ├── Interfaces/
│   ├── Services/
│   └── DTOs/
└── README.md
```

---

## System Requirements

1. **Operating System**: Windows 10/11 or Server 2019+
2. **Visual Studio 2026** with ASP.NET Core workload
3. **SQL Server 2019** or higher
4. **.NET Core 8.0** SDK
5. **Minimum RAM**: 8GB
6. **Disk Space**: 2GB

---

## Installation Steps

### Step 1: Clone/Download Project
```bash
# Download from provided GitHub repository
git clone https://github.com/your-repo/SchoolManagementSystem.git
cd SchoolManagementSystem
```

### Step 2: Configure Database Connection
Edit `appsettings.json`:
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=YOUR_SERVER;Database=SchoolManagementSystem;User Id=sa;Password=YOUR_PASSWORD;Encrypt=true;TrustServerCertificate=true;"
  }
}
```

### Step 3: Apply Database Migrations
```bash
cd SchoolManagementSystem.Web

# Create and apply initial migration
dotnet ef migrations add InitialCreate
dotnet ef database update

# Apply seed data
dotnet ef migrations add SeedData
dotnet ef database update
```

### Step 4: Restore NuGet Packages
```bash
dotnet restore
```

### Step 5: Build Solution
```bash
dotnet build
```

### Step 6: Run Application
```bash
dotnet run
# Application will start at https://localhost:5001
```

---

## Default Login Credentials

| Role | Username | Password | Kwacha Currency |
|------|----------|----------|-----------------|
| System Administrator | sysadmin | Admin@123 | ZMW |
| Branch Manager | manager1 | Manager@123 | ZMW |
| Finance Officer | finance1 | Finance@123 | ZMW |
| Teacher | teacher1 | Teacher@123 | ZMW |

---

## Database Configuration

### Connection String (SQL Server)
```
Server=localhost;Database=SchoolManagementSystem;User Id=sa;Password=YourPassword;Encrypt=true;TrustServerCertificate=true;
```

### Connection String (SQL Server Express)
```
Server=.\SQLEXPRESS;Database=SchoolManagementSystem;User Id=sa;Password=YourPassword;Encrypt=false;
```

---

## Key Features Implemented

### 1. **Dashboard**
- Registration statistics per grade level
- Total invoices in the year
- Total payments in the year
- Charts and visual analytics

### 2. **Menu Management**
- Dynamic menu system with role-based access
- Parent and child menu items
- Parent Menus:
  - Students
  - Finances
  - Registration
  - Results (Examination)
  - Payments
  - Curriculum
  - Staff Members
  - Reports
  - Administration

### 3. **Students Module**
- Add Student with auto-generated StudentID (Format: YY + Sequence, e.g., 251)
- Multi-tab form (Student Details, Subject Details)
- Student Overview with personal data, registration details, payment history
- Student Balance tracking
- Exemptions management

### 4. **Finance Module**
- Invoice generation and management
- Payment statement tracking
- Balance calculations
- Transaction history

### 5. **Registration Module**
- Add/Remove Subjects for students
- Registration form with auto-fee calculation
- Subject allocation based on grade
- Returning student registration with balance alerts
- Receipt generation and printing

### 6. **Examination Module**
- Continuous Assessment (CA) entry and tracking
- Final Grades and Results
- Results slip generation per semester/year
- Grade calculations and moderation

### 7. **Reports Module**
- Daily, Weekly, Monthly, Yearly payment reports
- Results slips (per student, semester, year)
- Student transcripts (all academic years)
- Student balance per grade
- Student list per grade/class
- Fees list
- Excel & PDF export functionality

### 8. **Administration Module**
- Full CRUD operations on all master tables:
  - Grades
  - Subjects
  - Fees
  - Academic Years
  - Semesters
  - Students
  - Staff Members
  - Transactions
  - User Management
- Role-based access control

### 9. **Staff Members Module**
- Add staff with National Registration Number (Format: 000000/00/0)
- Phone number (Format: 000 000000000)
- Department/Branch assignment
- Qualifications and positions

---

## Database Tables Overview

| Table Name | Purpose |
|-----------|---------|
| Students | Core student information |
| StudentDetails | Extended student details |
| StudentBalance | Track student financial status |
| Grades | Class/Grade information |
| GradeLevel | Grade levels (Primary 1-6, Secondary 1-4, etc.) |
| Subject | Subject/Course definitions |
| GradeDetails | Student registration per subject per year |
| Fees | Fee structure by grade |
| Transactions | All financial transactions |
| ContinuousAssessment | CA marks and assessments |
| Examination | Exam results and grades |
| Users | System user accounts and roles |
| Menu | Dynamic navigation menu |
| UserForm | Role-based form permissions |
| AuditLogs | System audit trail |
| BackupHistory | Database backup tracking |

---

## API Endpoints (RESTful)

### Students
```
GET    /api/students                    - Get all students
POST   /api/students                    - Create new student
GET    /api/students/{id}               - Get student details
PUT    /api/students/{id}               - Update student
DELETE /api/students/{id}               - Delete student
GET    /api/students/{id}/balance       - Get student balance
```

### Finances
```
GET    /api/invoices                    - Get all invoices
POST   /api/invoices                    - Create invoice
GET    /api/invoices/{studentId}        - Get student invoices
GET    /api/payments                    - Get payment history
POST   /api/payments                    - Record payment
```

### Grades & Subjects
```
GET    /api/grades                      - Get all grades
GET    /api/subjects                    - Get all subjects
GET    /api/gradedetails/{studentId}    - Get student registrations
```

---

## Stored Procedures Included

1. `sp_GenerateStudentID` - Auto-generate student ID
2. `sp_CalculateStudentBalance` - Calculate current balance
3. `sp_GetPaymentStatement` - Get payment details by student
4. `sp_GenerateResultsSlip` - Generate results report
5. `sp_GetTranscript` - Get complete student transcript
6. `sp_DailyPaymentReport` - Daily payment summary
7. `sp_StudentBalanceByGrade` - Balance summary per grade
8. `sp_BackupDatabase` - Automated backup procedure

---

## Security Features

✅ SQL Injection Prevention (Parameterized Queries)
✅ Role-Based Access Control (RBAC)
✅ Password Hashing (bcrypt)
✅ Session Management
✅ Audit Logging
✅ Data Encryption
✅ CORS Configuration
✅ HTTPS Enforcement

---

## Performance Optimizations

- Database indexing on frequently queried fields
- Query optimization with stored procedures
- Lazy loading and eager loading strategies
- Caching implementation
- Connection pooling
- Pagination for large datasets

---

## Backup & Restore

### Automated Backup
```bash
# Backup stored in: App_Data/Backups/
# Automatic daily backup at 2:00 AM
```

### Manual Backup
```sql
BACKUP DATABASE SchoolManagementSystem 
TO DISK = 'C:\Backups\SMS_Backup.bak' 
WITH FORMAT, INIT, NAME = 'Full Backup'
```

### Restore
```sql
RESTORE DATABASE SchoolManagementSystem 
FROM DISK = 'C:\Backups\SMS_Backup.bak'
```

---

## Configuration Files

### appsettings.json
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.;Database=SchoolManagementSystem;User Id=sa;Password=;Encrypt=false;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  },
  "AllowedHosts": "*",
  "AppSettings": {
    "Currency": "ZMW",
    "SchoolName": "School Name",
    "BranchCount": 5
  }
}
```

---

## Troubleshooting

### Issue: Database Connection Failed
**Solution**: 
- Verify SQL Server is running
- Check connection string in appsettings.json
- Ensure database user has proper permissions

### Issue: Migrations Failed
**Solution**:
```bash
# Remove failed migration
dotnet ef migrations remove

# Recreate migration
dotnet ef migrations add YourMigrationName
dotnet ef database update
```

### Issue: Port Already in Use
**Solution**:
```bash
# Run on different port
dotnet run --urls="https://localhost:5002"
```

---

## Deployment

### Deploy to IIS
1. Publish: `dotnet publish -c Release`
2. Copy published files to IIS folder
3. Create IIS Application Pool (.NET Core)
4. Set application pool to "No Managed Code"
5. Configure web.config

### Deploy to Azure
1. Create Azure SQL Database
2. Update connection string
3. Publish to Azure App Service via Visual Studio

---

## Support & Documentation

- **Technical Manual**: See `TECHNICAL_MANUAL.md`
- **User Manual**: See `USER_MANUAL.md`
- **API Documentation**: See `API_DOCUMENTATION.md`

---

## License

Proprietary - School Management System

---

## Contact

For support and inquiries, contact your development team.

---

**Version**: 1.0.0
**Last Updated**: December 2025
**Currency**: Zambian Kwacha (ZMW)
