# School Management System - Technical Manual
## Setup, Configuration & Development Guide

**Version:** 1.0.0  
**Last Updated:** December 4, 2025  
**For:** Developers, IT Administrators, System Administrators  

---

## 📋 Table of Contents

1. [System Requirements](#system-requirements)
2. [Installation & Setup](#installation--setup)
3. [Database Configuration](#database-configuration)
4. [Project Structure](#project-structure)
5. [Configuration Files](#configuration-files)
6. [Entity Framework Core](#entity-framework-core)
7. [Authentication & Authorization](#authentication--authorization)
8. [Deployment](#deployment)
9. [Troubleshooting](#troubleshooting)
10. [API Documentation](#api-documentation)

---

## System Requirements

### Hardware Requirements
- **Processor:** Intel i5 or equivalent (minimum 2.0 GHz)
- **RAM:** 8 GB minimum (16 GB recommended)
- **Storage:** 50 GB SSD for development, 100 GB for production
- **Network:** 10 Mbps minimum for production

### Software Requirements
- **Operating System:** Windows 10/11, Windows Server 2019/2022, Linux, macOS
- **Visual Studio:** 2025/2026 Community, Professional, or Enterprise
- **.NET SDK:** 8.0 or later
- **SQL Server:** 2019, 2022, or Express Edition
- **SQL Server Management Studio:** Latest version
- **IIS:** 10.0+ (for production deployment)

### Browser Requirements
- Chrome 90+
- Firefox 88+
- Edge 90+
- Safari 14+

---

## Installation & Setup

### Step 1: Download Required Tools

1. **Visual Studio 2025/2026**
   - Download from: https://visualstudio.microsoft.com/
   - Select: ASP.NET and web development workload
   - Include: .NET Framework, Entity Framework Core tools

2. **SQL Server Express/Developer**
   - Download from: https://www.microsoft.com/en-us/sql-server/sql-server-downloads

3. **.NET 8.0 SDK**
   - Download from: https://dotnet.microsoft.com/download/dotnet/8.0

### Step 2: Create New ASP.NET Core Project

```bash
# Using .NET CLI
dotnet new webapp -n SchoolManagementSystem
cd SchoolManagementSystem

# Or use Visual Studio:
# File > New > Project > ASP.NET Core Web App
```

### Step 3: Install Required NuGet Packages

**Using Package Manager Console:**

```powershell
Install-Package Microsoft.EntityFrameworkCore -Version 8.0.0
Install-Package Microsoft.EntityFrameworkCore.SqlServer -Version 8.0.0
Install-Package Microsoft.EntityFrameworkCore.Tools -Version 8.0.0
Install-Package Microsoft.AspNetCore.Identity.EntityFrameworkCore -Version 8.0.0
Install-Package Microsoft.AspNetCore.Authentication.Cookies -Version 2.2.479
Install-Package System.Data.SqlClient -Version 4.8.5
```

**Or using .NET CLI:**

```bash
dotnet add package Microsoft.EntityFrameworkCore --version 8.0.0
dotnet add package Microsoft.EntityFrameworkCore.SqlServer --version 8.0.0
dotnet add package Microsoft.EntityFrameworkCore.Tools --version 8.0.0
dotnet add package Microsoft.AspNetCore.Identity.EntityFrameworkCore --version 8.0.0
```

### Step 4: Create Project Structure

Create the following folder structure:

```
SchoolManagementSystem/
├── Controllers/
├── Models/
├── Services/
├── Data/
├── Views/
├── Pages/
├── wwwroot/
│   ├── css/
│   ├── js/
│   └── lib/
├── Migrations/
├── appsettings.json
├── Program.cs
├── SMS.csproj
└── README.md
```

### Step 5: Add Code Files

1. Copy all C# code from **SMS-CSharp-Code.txt** to appropriate locations
2. Create Models in `Models/` folder
3. Create Services in `Services/` folder
4. Create Controllers in `Controllers/` folder
5. Create DbContext in `Data/` folder

---

## Database Configuration

### Connection String Setup

**File:** `appsettings.json`

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.\\SQLEXPRESS;Database=SchoolManagementSystem;Trusted_Connection=true;TrustServerCertificate=true;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information"
    }
  },
  "AllowedHosts": "*"
}
```

### Using SQL Server (Network)

For network SQL Server:

```json
"DefaultConnection": "Server=YOUR_SERVER_IP;Database=SchoolManagementSystem;User Id=sa;Password=YOUR_PASSWORD;"
```

### Using Azure SQL Database

```json
"DefaultConnection": "Server=tcp:your-server.database.windows.net,1433;Initial Catalog=SchoolManagementSystem;Persist Security Info=False;User ID=yourusername;Password=yourpassword;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;"
```

### Create Migrations

```bash
# Create initial migration
dotnet ef migrations add InitialCreate

# Update database
dotnet ef database update

# View migration status
dotnet ef migrations list
```

### Execute SQL Scripts

1. Open SQL Server Management Studio
2. Connect to your SQL Server instance
3. Create new query window
4. Copy contents from **SMS-Database-Scripts.sql**
5. Execute the script
6. Verify tables were created successfully

---

## Project Structure

### Models (Domain Classes)

All entity models are located in `Models/` folder:

- `User.cs` - System users and authentication
- `Student.cs` - Student records
- `Teacher.cs` - Teacher/staff records
- `Course.cs` - Course definitions
- `SchoolClass.cs` - Class/grade definitions
- `Enrollment.cs` - Student course enrollment
- `Grade.cs` - Student grades
- `Fee.cs` - Fee types and amounts
- `FeePayment.cs` - Payment records
- `CourseAssignment.cs` - Teacher to course mapping
- `AuditLog.cs` - System audit trail

### Controllers

Located in `Controllers/` folder:

- `HomeController.cs` - Dashboard and home page
- `StudentController.cs` - Student management (CRUD)
- `TeacherController.cs` - Teacher management
- `CourseController.cs` - Course management
- `EnrollmentController.cs` - Enrollment management
- `GradeController.cs` - Grade entry and viewing
- `FeeController.cs` - Fee management
- `ReportController.cs` - Reporting and analytics
- `AdminController.cs` - System administration

### Services

Located in `Services/` folder:

- `StudentService.cs` - Student business logic
- `TeacherService.cs` - Teacher business logic
- `GradeService.cs` - Grade calculation and management
- `FeeService.cs` - Fee and payment processing
- `ReportService.cs` - Report generation
- `AuthService.cs` - Authentication and authorization

### Data Access

Located in `Data/` folder:

- `SchoolDbContext.cs` - Entity Framework DbContext
- `Migrations/` - Database migration files

---

## Configuration Files

### Program.cs

Main application configuration file:

```csharp
using SchoolManagementSystem.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services
builder.Services.AddControllersWithViews();
builder.Services.AddScoped<IStudentService, StudentService>();
builder.Services.AddScoped<ITeacherService, TeacherService>();
builder.Services.AddScoped<IGradeService, GradeService>();
builder.Services.AddScoped<IFeeService, FeeService>();

// Add DbContext
builder.Services.AddDbContext<SchoolDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add Authentication
builder.Services.AddAuthentication("CookieAuthentication")
    .AddCookie("CookieAuthentication", options =>
    {
        options.LoginPath = "/Account/Login";
        options.AccessDeniedPath = "/Account/AccessDenied";
    });

var app = builder.Build();

// Configure middleware
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

### appsettings.json

Application settings and configuration:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.\\SQLEXPRESS;Database=SchoolManagementSystem;Trusted_Connection=true;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft": "Warning"
    }
  },
  "AllowedHosts": "*",
  "Serilog": {
    "MinimumLevel": "Information",
    "WriteTo": [
      {
        "Name": "File",
        "Args": {
          "path": "logs/sms-.txt",
          "rollingInterval": "Day"
        }
      }
    ]
  }
}
```

---

## Entity Framework Core

### DbContext Configuration

```csharp
public class SchoolDbContext : DbContext
{
    public SchoolDbContext(DbContextOptions<SchoolDbContext> options) 
        : base(options) { }

    public DbSet<User> Users { get; set; }
    public DbSet<Student> Students { get; set; }
    public DbSet<Teacher> Teachers { get; set; }
    public DbSet<Course> Courses { get; set; }
    // ... other DbSets

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        // Fluent API configurations
        modelBuilder.Entity<User>()
            .HasIndex(u => u.Username)
            .IsUnique();
        
        // Foreign key relationships
        modelBuilder.Entity<Student>()
            .HasOne(s => s.CurrentClass)
            .WithMany(c => c.Students)
            .HasForeignKey(s => s.CurrentClassId);
    }
}
```

### Running Migrations

```bash
# Create a new migration
dotnet ef migrations add MigrationName

# Update database with latest migration
dotnet ef database update

# Revert to previous migration
dotnet ef database update PreviousMigrationName

# Remove last migration
dotnet ef migrations remove

# Script migrations (generate SQL)
dotnet ef migrations script
```

---

## Authentication & Authorization

### Role-Based Authorization

```csharp
[Authorize(Roles = "Admin,Principal")]
public class AdminController : Controller
{
    public IActionResult Index()
    {
        return View();
    }
}
```

### Policy-Based Authorization

```csharp
// In Program.cs
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy =>
        policy.RequireRole("Admin"));
    
    options.AddPolicy("TeacherAccess", policy =>
        policy.RequireRole("Teacher", "Principal", "Admin"));
});

// In Controller
[Authorize(Policy = "AdminOnly")]
public IActionResult ManageUsers()
{
    return View();
}
```

### User Roles

- **Admin** - Full system access
- **Principal** - School oversight and reporting
- **AcademicAdmin** - Academic management
- **Teacher** - Grade entry and student viewing
- **FinanceOfficer** - Fee and payment management
- **Registrar** - Enrollment and records
- **Parent** - Child records viewing only
- **Student** - Own records viewing only

---

## Deployment

### Development Deployment (IIS)

1. **Build Release Version**
   ```bash
   dotnet publish -c Release -o ./publish
   ```

2. **Create IIS Application Pool**
   - Open IIS Manager
   - Create new Application Pool (.NET CLR version: No Managed Code)

3. **Create Website**
   - Physical path: point to publish folder
   - Binding: http://localhost:80

4. **Configure AppPool Identity**
   - Set to appropriate user with database access

### Azure Deployment

```bash
# Login to Azure
az login

# Create resource group
az group create --name sms-rg --location eastus

# Create App Service Plan
az appservice plan create --name sms-plan --resource-group sms-rg --sku FREE

# Deploy app
az webapp create --resource-group sms-rg --plan sms-plan --name sms-app
az webapp deployment source config-zip --resource-group sms-rg --name sms-app --src publish.zip
```

---

## Troubleshooting

### Common Issues and Solutions

| Issue | Cause | Solution |
|-------|-------|----------|
| Connection timeout | SQL Server not running | Start SQL Server service |
| Migration fails | Missing package | Install Entity Framework tools |
| 404 Not Found | Controller not registered | Check routing in Program.cs |
| Authentication fails | Invalid credentials | Reset password in database |
| Slow queries | Missing indexes | Run index creation scripts |

### Debug Mode

```bash
# Run in debug mode
dotnet run

# Visual Studio: Press F5 or Debug > Start Debugging

# Attach debugger to running process
dotnet attach --pid <process-id>
```

---

## API Documentation

### Authentication API

**Endpoint:** `POST /api/auth/login`

Request:
```json
{
  "username": "teacher",
  "password": "password123"
}
```

Response:
```json
{
  "success": true,
  "message": "Login successful",
  "token": "jwt_token_here",
  "user": {
    "id": 1,
    "username": "teacher",
    "role": "Teacher"
  }
}
```

### Student API

**List Students**
```
GET /api/students
Authorization: Bearer token
```

**Get Student**
```
GET /api/students/{id}
```

**Create Student**
```
POST /api/students
Content-Type: application/json

{
  "studentId": "S005",
  "firstName": "John",
  "lastName": "Doe",
  "dateOfBirth": "2008-01-15",
  "email": "john@student.com"
}
```

**Update Student**
```
PUT /api/students/{id}
Content-Type: application/json
```

**Delete Student**
```
DELETE /api/students/{id}
```

### Grade API

**Get Student Grades**
```
GET /api/grades/student/{studentId}
```

**Submit Grade**
```
POST /api/grades
Content-Type: application/json

{
  "studentId": 1,
  "courseId": 1,
  "numericGrade": 92,
  "teacherId": 1
}
```

---

## Support & Resources

- **Microsoft Docs:** https://docs.microsoft.com/dotnet
- **Entity Framework Core:** https://docs.microsoft.com/en-us/ef/core/
- **ASP.NET Core:** https://docs.microsoft.com/en-us/aspnet/core/
- **SQL Server:** https://docs.microsoft.com/en-us/sql/sql-server/

---

**End of Technical Manual**
