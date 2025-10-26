using Microsoft.AspNetCore.Mvc;

public class EmailRequest
{
    public string Nombre { get; set; }
    public string Correo { get; set; }
    public string Asunto { get; set; }
    public string Mensaje { get; set; }
}
