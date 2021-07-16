using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace ZumNet.Web.Models
{
    public class WorkTimeViewModels
    {
        public string WorkStatus { get; set; }

        public string PlanInTime { get; set; }

        public string PlanOutTime { get; set; }

        public string InTime { get; set; }

        public string OutTime { get; set; }
    }
}