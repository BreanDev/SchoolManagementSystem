# School Management System - Quick Start Guide
## Get Up & Running in 30 Minutes

**Version:** 1.0.0  
**Last Updated:** December 4, 2025  
**Time Estimate:** 30 minutes for developers, 5 minutes for users

---

## 🚀 For Developers (30 minutes)

### 1. Prerequisites (5 minutes)
- [ ] Visual Studio 2025/2026 installed
- [ ] .NET 8.0 SDK installed
- [ ] SQL Server Express or Developer Edition installed
- [ ] All files downloaded from this package

### 2. Create Project (5 minutes)

**Option A: Using Visual Studio**
1. Open Visual Studio
2. File → New → Project
3. Select "ASP.NET Core Web App"
4. Name: "SchoolManagementSystem"
5. Click Create

**Option B: Using Command Line**
```bash
dotnet new webapp -n SchoolManagementSystem
cd SchoolManagementSystem
```

### 3. Install NuGet Packages (3 minutes)

Open Package Manager Console and run:

```powershell
Install-Package Microsoft.EntityFrameworkCore -Version 8.0.0
Install-Package Microsoft.EntityFrameworkCore.SqlServer -Version 8.0.0
Install-Package Microsoft.EntityFrameworkCore.Tools -Version 8.0.0
```

Or command line:
```bash
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.SqlServer
dotnet add package Microsoft.EntityFrameworkCore.Tools
```

### 4. Add Code Files (5 minutes)

1. Create folder structure:
   - Controllers/
   - Models/
   - Services/
   - Data/
   - Views/

2. Copy all code from **SMS-CSharp-Code.txt** to appropriate folders:
   - Models/ → Model classes
   - Services/ → Service classes
   - Data/ → DbContext.cs

3. Copy **Program.cs** configuration

### 5. Configure Database (10 minutes)

**Step 1: Update appsettings.json**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=.\\SQLEXPRESS;Database=SchoolManagementSystem;Trusted_Connection=true;TrustServerCertificate=true;"
  }
}
```

**Step 2: Open SQL Server Management Studio**
1. Open SSMS
2. Connect to your SQL Server
3. Create new query
4. Copy contents of **SMS-Database-Scripts.sql**
5. Execute script
6. Verify tables created (should see 11 tables)

**Step 3: Verify Migration**
```bash
dotnet ef database update
```

### 6. Run Application (2 minutes)

```bash
dotnet run
```

Or press F5 in Visual Studio.

**Application will be available at:**
- http://localhost:5000
- http://localhost:5001 (HTTPS)

### 7. Test Login

**Default test accounts:**

| Username | Password | Role |
|----------|----------|------|
| admin | password | Admin |
| teacher | password | Teacher |
| finance | password | Finance Officer |

---

## 👥 For End Users (5 minutes)

### 1. Access the System
1. Open browser (Chrome, Firefox, Edge)
2. Navigate to: http://school-domain.com/sms
3. Enter credentials provided by administrator

### 2. Dashboard Overview
- **Welcome section** - Shows your name and role
- **Quick statistics** - Overview of key metrics
- **Recent activities** - Latest system changes
- **Quick links** - Your most-used features

### 3. Common Tasks

**I'm a Student:**
1. Login with student account
2. Click "My Grades" to view grades
3. Click "Fee Status" to check payments
4. View "My Profile" for personal details

**I'm a Teacher:**
1. Login with teacher account
2. Click "Grade Entry" to submit grades
3. Click "My Classes" to see assigned courses
4. View student lists and attendance

**I'm an Administrator:**
1. Login with admin account
2. Click "Student Management" to add/edit students
3. Click "Reports" to generate system reports
4. Click "Users" to manage login accounts

**I'm in Finance:**
1. Login with finance account
2. Click "Fee Management" to track payments
3. Click "Record Payment" to process payments
4. Generate payment reports

### 4. Logout
1. Click profile icon (top-right)
2. Select "Logout"
3. You are logged out

---

## 📁 File Descriptions

| File | Purpose |
|------|---------|
| SMS-Project-Overview.md | High-level project description |
| SMS-CSharp-Code.txt | Complete C# code (Models, Services, Controllers) |
| SMS-Database-Scripts.sql | SQL database setup and initialization |
| SMS-Technical-Manual.md | Developer setup and configuration guide |
| SMS-User-Manual.md | End-user feature documentation |
| SMS-Quick-Start.md | This file - quick reference |

---

## 🔧 Common Development Tasks

### Add New User Role

1. Open `Models/User.cs`
2. Update Role property with new role
3. In `Program.cs`, add authorization policy:

```csharp
builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("NewRole", policy =>
        policy.RequireRole("NewRole"));
});
```

### Create New Entity/Model

1. Create class in `Models/` folder:

```csharp
public class NewEntity
{
    public int Id { get; set; }
    public string Name { get; set; }
}
```

2. Add DbSet to `SchoolDbContext.cs`:

```csharp
public DbSet<NewEntity> NewEntities { get; set; }
```

3. Create migration:

```bash
dotnet ef migrations add AddNewEntity
dotnet ef database update
```

### Create New Service

1. Create interface in `Services/`:

```csharp
public interface INewService
{
    Task<NewEntity> GetByIdAsync(int id);
}
```

2. Create implementation:

```csharp
public class NewService : INewService
{
    private readonly SchoolDbContext _context;
    
    public NewService(SchoolDbContext context)
    {
        _context = context;
    }
    
    public async Task<NewEntity> GetByIdAsync(int id)
    {
        return await _context.NewEntities.FindAsync(id);
    }
}
```

3. Register in `Program.cs`:

```csharp
builder.Services.AddScoped<INewService, NewService>();
```

### Create New Controller Action

1. Add method to controller:

```csharp
[HttpGet("{id}")]
public async Task<IActionResult> Details(int id)
{
    var entity = await _service.GetByIdAsync(id);
    if (entity == null)
        return NotFound();
    
    return View(entity);
}
```

2. Create corresponding View in `Views/ControllerName/` folder

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| "Connection timeout" | Verify SQL Server is running and connection string is correct |
| "Entity Framework not found" | Install NuGet packages again |
| "Database tables not created" | Run migration: `dotnet ef database update` |
| "Login fails" | Check username/password in Users table or run SQL scripts again |
| "Port already in use" | Change port in `appsettings.json` or launchSettings.json |
| "Migrations conflict" | Delete migrations folder and recreate: `dotnet ef migrations add Initial` |

---

## 📊 Database Schema Overview

**11 Tables:**
1. **Users** - System login and authentication
2. **Students** - Student records and information
3. **Teachers** - Staff/teacher information
4. **Courses** - Course definitions and details
5. **SchoolClasses** - Class and grade information
6. **Enrollments** - Student to course enrollment
7. **Grades** - Student grades and academic records
8. **Fees** - Fee types and fee structure
9. **FeePayments** - Payment history and records
10. **CourseAssignments** - Teacher to course mapping
11. **AuditLogs** - System activity tracking

---

## 🔐 Default Test Data

### Test Users
```
Username: admin       | Password: password | Role: Admin
Username: principal   | Password: password | Role: Principal
Username: academic    | Password: password | Role: AcademicAdmin
Username: teacher     | Password: password | Role: Teacher
Username: finance     | Password: password | Role: FinanceOfficer
Username: registrar   | Password: password | Role: Registrar
```

### Test Students
```
S001 - David Anderson - Form 1A
S002 - Lisa Martinez - Form 1A
S003 - James Taylor - Form 2A
S004 - Jennifer Garcia - Form 1B
```

### Test Teachers
```
T001 - John Smith (Mathematics)
T002 - Sarah Johnson (English)
T003 - Michael Williams (Physics)
T004 - Emily Brown (History)
```

---

## 📈 Development Roadmap

### Phase 1: Foundation (Weeks 1-2)
- ✅ Models and database setup
- ✅ Authentication and authorization
- ✅ CRUD operations for core entities

### Phase 2: Features (Weeks 3-4)
- Grade management
- Fee tracking
- Enrollment system
- Reporting

### Phase 3: Enhancement (Weeks 5-6)
- Advanced reports (PDF, Excel export)
- API endpoints
- Mobile responsive design
- Performance optimization

### Phase 4: Production (Week 7-8)
- Security hardening
- Load testing
- Deployment setup
- Training and documentation

---

## 🔗 Resources & Documentation

### Official Documentation
- [Microsoft .NET Documentation](https://docs.microsoft.com/dotnet)
- [Entity Framework Core Docs](https://docs.microsoft.com/en-us/ef/core/)
- [ASP.NET Core Docs](https://docs.microsoft.com/en-us/aspnet/core/)
- [SQL Server Documentation](https://docs.microsoft.com/en-us/sql/sql-server/)

### Online Learning
- [Microsoft Learn](https://learn.microsoft.com)
- [Pluralsight](https://pluralsight.com)
- [Udemy](https://www.udemy.com)

### Community Help
- [Stack Overflow](https://stackoverflow.com/questions/tagged/asp.net-core)
- [Reddit r/dotnet](https://reddit.com/r/dotnet)
- [GitHub Discussions](https://github.com)

---

## 💡 Tips for Success

1. **Start with database** - Get SQL setup right first
2. **Follow naming conventions** - Consistency matters
3. **Use version control** - Git, GitHub, Azure Repos
4. **Test frequently** - Don't wait until the end
5. **Keep backups** - Database backups are essential
6. **Document changes** - For future reference
7. **Comment code** - Help yourself and others
8. **Follow DRY principle** - Don't repeat yourself

---

## 📞 Support Resources

**Developer Support:**
- Email: developers@school.edu
- Slack: #development channel
- Hours: Monday-Friday 9 AM - 5 PM

**User Support:**
- Email: support@school.edu
- Phone: +1-555-0000
- Help Desk Portal: help.school.edu

---

## 🎓 Next Steps

1. **Review** the full Technical Manual for detailed setup
2. **Follow** the User Manual for feature walkthroughs
3. **Customize** the system for your school's needs
4. **Train** staff and students on usage
5. **Deploy** to production environment
6. **Monitor** system performance and usage

---

**Congratulations! You now have a fully functional School Management System.**

For more information, refer to the complete documentation package included with this project.
