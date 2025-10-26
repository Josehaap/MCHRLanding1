namespace IntellingCore.API.Models
{
    public class ContactFormModel
    {
        public string Nombre { get; set; }
        public string Email { get; set; }
        public string Asunto { get; set; }
        public string Mensaje { get; set; }
        public bool AceptaPolitica { get; set; }
    }
}
