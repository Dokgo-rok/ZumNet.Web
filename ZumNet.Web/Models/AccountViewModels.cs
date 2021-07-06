using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ZumNet.Web.Models
{
    public class AccountViewModels
    {
        [Required]
        [Display(Name = "로그인 아이디")]
        [DataType(DataType.Text)]
        public string LoginId { get; set; }

        [Required]
        [Display(Name = "비밀번호")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [Display(Name = "아이디 저장")]
        public bool RememberMe { get; set; }
    }
}