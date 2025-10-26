using IntellingCore.API.Models;
using System.Net;
using System.Net.Mail;
using Microsoft.AspNetCore.Mvc;

namespace IntellingCore.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ContactoController : ControllerBase
    {
        [HttpPost]
        public IActionResult EnviarCorreo([FromBody] ContactFormModel model)
        {
            if (!model.AceptaPolitica)
                return BadRequest("Debe aceptar la política de privacidad.");

            // Aquí va la configuración SMTP (usa tu servidor real)
            var smtpClient = new SmtpClient("smtp.gmail.com")
            {
                Port = 587,
                Credentials = new NetworkCredential("emailintellingcore@gmail.com", "ttib eixm otca cvha"),
                EnableSsl = true,
            };

            var mailMessage = new MailMessage
            {
                From = new MailAddress("emailintellingcore@gmail.com"),
                Subject = model.Asunto,
                Body = $"Nombre: {model.Nombre}\nEmail: {model.Email}\nMensaje:\n{model.Mensaje}",
                IsBodyHtml = false,
            };

            mailMessage.To.Add("info@mindshore.io");

            try
            {
                smtpClient.Send(mailMessage);
                return Ok("Correo enviado correctamente");
            }
            catch (Exception ex)
            {
                return StatusCode(500, "Error al enviar correo: " + ex.Message);
            }
        }
    }
}
