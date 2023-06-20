var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => "Hello World!\n");
app.MapGet("/hello", () => "{\"message\":\"Hello DOTNET World\",\"valid\":true}");

app.Run();
