using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ZumNet.Web.Models
{
    public class AccountViewModels
    {
        [Required]
        [Display(Name = "LoginId", ResourceType = typeof(Resources.Global))]
        [DataType(DataType.Text)]
        public string LoginId { get; set; }

        [Required]
        [Display(Name = "Password", ResourceType = typeof(Resources.Global))]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Display(Name = "RememberMe", ResourceType = typeof(Resources.Global))]
        public bool RememberMe { get; set; }
    }
}