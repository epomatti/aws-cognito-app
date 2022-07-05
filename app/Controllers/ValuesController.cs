using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace app.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ValuesController : ControllerBase
{
  [HttpGet]
  [Authorize]
  public ActionResult<IEnumerable<string>> Get()
  {
    return new string[] { "value1", "value2" };
  }
}
