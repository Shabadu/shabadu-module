using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace Shabadu.SXA.Commands
{
	[Cmdlet("Compare", "MediaItem")]
	public class CompareMediaItem : PSCmdlet
	{
		[Parameter(Mandatory = true, ValueFromRemainingArguments = true)]
		public string YamlFile { get; set; }

		[Parameter(Mandatory = true)]
		public string SourceFile { get; set; }

		protected bool Result { get; set; }

		protected override void ProcessRecord()
		{
			try
			{

			}
			finally
			{
				WriteObject(Result);
			}
		}
	}
}
