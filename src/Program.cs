var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => Results.Ok(new
{
    message = "Hello from the GitLab CI/CD pipeline!",
    environment = "container"
}));

app.MapGet("/health", () => Results.Ok(new
{
    status = "healthy"
}));

app.Run();
