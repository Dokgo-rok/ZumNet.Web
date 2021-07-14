using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ZumNet.Web.Models
{
    public class AccountViewModels
    {
        [Required]
        [Display(Name = "lbl_LoginId", ResourceType = typeof(Resources.Global))]
        [DataType(DataType.Text)]
        public string LoginId { get; set; }

        [Required]
        [Display(Name = "lbl_Password", ResourceType = typeof(Resources.Global))]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Display(Name = "lbl_RememberMe", ResourceType = typeof(Resources.Global))]
        public bool RememberMe { get; set; }
    }
}