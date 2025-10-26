using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/[controller]")]
public class EmailController : ControllerBase
{
    [HttpPost]
    public IActionResult SendEmail([FromBody] EmailRequest model)
    {
        // Aquí haces el envío real con MailKit o SMTP
        return Ok("Correo enviado");
    }
}
