param (
    [ValidateSet("dev", "pq", "si", "sitd1", "pd", "sat", "sb", "prod")][string]$env = "prod",
    [ValidateSet("site", "svc", "pdfsvc", "valsvc", "all")][string]$serverType = "pdfsvc",
    [switch]$omitGood,
    [string]$omitVersion,
    [switch]$timeoutOnly,
    [switch]$outputIpAddresses
)

# Import-Module PSWriteColor

$serverTypeList = @()
if ($serverType -eq "all") {
    $serverTypeList = @("site", "svc", "valsvc", "pdfsvc")
    if ($outputIpAddresses) {
        throw "ServerType cannot be 'all' when requesting IP Address output"
    }
}
else {
    $serverTypeList += $serverType
}

$serverConfig = @{ }
$serverConfig["dev"] = @{ }
$serverConfig["pq"] = @{ }
$serverConfig["si"] = @{ }
$serverConfig["sitd1"] = @{ }
$serverConfig["pd"] = @{ }
$serverConfig["sat"] = @{ }
$serverConfig["sb"] = @{ }
$serverConfig["prod"] = @{ }

$serverConfig["dev"]["site"] = @(
    "oitotwdev1.riaqa.loc",
    "oitotwdev2.riaqa.loc"
)

$serverConfig["dev"]["svc"] = @(
    "oitotwdev3.riaqa.loc:9100",
    "oitotwdev4.riaqa.loc:9100"
)

$serverConfig["dev"]["pdfsvc"] = @(
    "PD-PDF-V01-0.riaqa.loc:9004",
    "PD-PDF-V02-0.riaqa.loc:9004",
    "PD-PDF-V03-0.riaqa.loc:9004",
    "PD-PDF-V04-0.riaqa.loc:9004",
    "PD-PDF-V05-0.riaqa.loc:9004",
    "PD-PDF-V06.riaqa.loc:9004",
    "PD-PDF-V07.riaqa.loc:9004"
)

$serverConfig["pq"]["site"] = @(
    "pq-otwgrs-01.pqrs.thomson.com",
    "pq-otwgrs-02.pqrs.thomson.com"
)

$serverConfig["pq"]["svc"] = @(
    "pq-otwgrsws-01.pqrs.thomson.com:9100",
    "pq-otwgrsws-02.pqrs.thomson.com:9100"
)

$serverConfig["pq"]["pdfsvc"] = @(
    "cr-pqwbprnt-02.pqrs.thomson.com:9004",
    "pq-gosysmob-03.pqrs.thomson.com:9004"
)

$serverConfig["si"]["site"] = @(
    "ctd1weborgwb.riaqa.loc",
    "ctd1weborgwb2.riaqa.loc"
)

$serverConfig["si"]["svc"] = @(
    "c111orgwebsvc1.riaqa.loc:9100",
    "c111orgwebsvc2.riaqa.loc:9100",
    "siotwwebsvc01.riaqa.loc:9100",
    "siotwwebsvc02.riaqa.loc:9100"
)

$serverConfig["si"]["pdfsvc"] = @(
    "c111si12app01.riaqa.loc:9004",
    "c111si12app04.riaqa.loc:9004",
    "cr-oitbatsi-v02.riaqa.loc:9004",
    "cr-ottappsi-v10.riaqa.loc:9004"
)

$serverConfig["sitd1"]["site"] = @(
    "ctd1otwweb1.riaqa.loc",
    "ctd1otwweb2.riaqa.loc"
)

$serverConfig["sitd1"]["svc"] = @(
    "ctd1otwsvc1.riaqa.loc:9100",
    "ctd1otwsvc2.riaqa.loc:9100",
    "sitd1otw01.riaqa.loc:9100",
    "sitd1otw02.riaqa.loc:9100",
    "sitd1otw03.riaqa.loc:9100",
    "sitd1otw04.riaqa.loc:9100",
    "sitd1otw05.riaqa.loc:9100",
    "sitd1otw06.riaqa.loc:9100",
    "sitd1otw07.riaqa.loc:9100",
    "sitd1otw08.riaqa.loc:9100",
    "sitd1otw09.riaqa.loc:9100",
    "sitd1otw10.riaqa.loc:9100"
)

$serverConfig["sitd1"]["pdfsvc"] = @(
    "ctd1silafiws1.riaqa.loc:9004",
    "ctd1silafiws2.riaqa.loc:9004",
    "ctd1silafiws3.riaqa.loc:9004",
    "ctd1silafiws4.riaqa.loc:9004"
)

$serverConfig["pd"]["site"] = @(
    "cr-pdotwws-v01.riaqa.loc",
    "cr-pdotwws-v02.riaqa.loc"
)

$serverConfig["pd"]["svc"] = @(
    "cr-pdotwws-v03.riaqa.loc:9100",
    "cr-pdotwws-v04.riaqa.loc:9100",
    "pd12otwws01.riaqa.loc:9100",
    "pd12otwws02.riaqa.loc:9100"
)

$serverConfig["pd"]["pdfsvc"] = @(
    "pd-pdf-v01.riaqa.loc:9004",
    "pd-pdf-v02.riaqa.loc:9004",
    "pd-pdf-v03.riaqa.loc:9004",
    "pd-pdf-v04.riaqa.loc:9004",
    "pd-pdf-v05.riaqa.loc:9004",
    "pdwebprintsvc1.riaqa.loc:9004",
    "pdwebprintsvc2.riaqa.loc:9004",
    "pdwebprintsvc3.riaqa.loc:9004",
    "pdwebprintsvc4.riaqa.loc:9004",
    "pdwebprintsvc5.riaqa.loc:9004"
)

$serverConfig["sat"]["site"] = @(
    "cr-satotwws-v1.riaqa.loc",
    "cr-satotwws-v2.riaqa.loc"
)

$serverConfig["sat"]["svc"] = @(
    "cr-satotwws-v3.riaqa.loc:9100",
    "cr-satotwws-v4.riaqa.loc:9100"
)

$serverConfig["sat"]["pdfsvc"] = @(
    "sat-pdf-v01.riaqa.loc:9004",
    "sat-pdf-v02.riaqa.loc:9004"
)

$serverConfig["sb"]["site"] = @(
    "c283kphsbotw1.intqa.thomsonreuters.com",
    "c582zsdsbotw2.intqa.thomsonreuters.com"
)

$serverConfig["sb"]["svc"] = @(
    "c170jmzsbows1.intqa.thomsonreuters.com:9100",
    "c617wepsbows2.intqa.thomsonreuters.com:9100"
)

$serverConfig["sb"]["pdfsvc"] = @(
    "c287scvsbpfs1.intqa.thomsonreuters.com:9004",
    "c638tdfsbpfs2.intqa.thomsonreuters.com:9004"
)

$serverConfig["prod"]["site"] = @(
    "c067gekotwweb.clrrs.loc",
    "c074tekotwweb.clrrs.loc",
    "c733ntuotwweb.clrrs.loc",
    "c940nseotwweb.clrrs.loc"
)

$serverConfig["prod"]["svc"] = @(
    "c001ebkgrsapp.clrrs.loc:9100",
    "c001nqmgrsapp.clrrs.loc:9100",
    "c004owvgrsapp.clrrs.loc:9100",
    "c005dkmgrsapp.clrrs.loc:9100",
    "c008pzxgrsapp.clrrs.loc:9100",
    "c009wdtotwsvc.clrrs.loc:9100",
    "c010jwegrsapp.clrrs.loc:9100",
    "c012plmgrsapp.clrrs.loc:9100",
    "c013iwlgrsapp.clrrs.loc:9100",
    "c013xmggrsapp.clrrs.loc:9100",
    "c015zumgrsapp.clrrs.loc:9100",
    "c016colgrsapp.clrrs.loc:9100",
    "c016spngrsapp.clrrs.loc:9100",
    "c018eqpgrsapp.clrrs.loc:9100",
    "c018rgngrsapp.clrrs.loc:9100",
    "c021uyagrsapp.clrrs.loc:9100",
    "c021vaqgrsapp.clrrs.loc:9100",
    "c022qzugrsapp.clrrs.loc:9100",
    "c024kragrsapp.clrrs.loc:9100",
    "c027egzgrsapp.clrrs.loc:9100",
    "c027vdlgrsapp.clrrs.loc:9100",
    "c027xfnotwsvc.clrrs.loc:9100",
    "c028agegrsapp.clrrs.loc:9100",
    "c028kgxgrsapp.clrrs.loc:9100",
    "c030mxygrsapp.clrrs.loc:9100",
    "c031hxggrsapp.clrrs.loc:9100",
    "c031usygrsapp.clrrs.loc:9100",
    "c035fvjgrsapp.clrrs.loc:9100",
    "c037goygrsapp.clrrs.loc:9100",
    "c037yrrgrsapp.clrrs.loc:9100",
    "c042oavgrsapp.clrrs.loc:9100",
    "c046ahhgrsapp.clrrs.loc:9100",
    "c046eaxgrsapp.clrrs.loc:9100",
    "c051dowgrsapp.clrrs.loc:9100",
    "c051dvkgrsapp.clrrs.loc:9100",
    "c052avogrsapp.clrrs.loc:9100",
    "c053xlsgrsapp.clrrs.loc:9100",
    "c056gwkgrsapp.clrrs.loc:9100",
    "c056rfrgrsapp.clrrs.loc:9100",
    "c057lobgrsapp.clrrs.loc:9100",
    "c058edggrsapp.clrrs.loc:9100",
    "c064wxzgrsapp.clrrs.loc:9100",
    "c065iuvgrsapp.clrrs.loc:9100",
    "c065jqggrsapp.clrrs.loc:9100",
    "c065qougrsapp.clrrs.loc:9100",
    "c066wxggrsapp.clrrs.loc:9100",
    "c067eedotwsvc.clrrs.loc:9100",
    "c067jfsgrsapp.clrrs.loc:9100",
    "c072crugrsapp.clrrs.loc:9100",
    "c077mqhgrsapp.clrrs.loc:9100",
    "c077saygrsapp.clrrs.loc:9100",
    "c077vhagrsapp.clrrs.loc:9100",
    "c082qvzgrsapp.clrrs.loc:9100",
    "c084bnygrsapp.clrrs.loc:9100",
    "c085hjfgrsapp.clrrs.loc:9100",
    "c086frqotwsvc.clrrs.loc:9100",
    "c088wkwgrsapp.clrrs.loc:9100",
    "c100xwugrsapp.clrrs.loc:9100",
    "c104wbjgrsapp.clrrs.loc:9100",
    "c107dplgrsapp.clrrs.loc:9100",
    "c107rcugrsapp.clrrs.loc:9100",
    "c108uzygrsapp.clrrs.loc:9100",
    "c108zbkgrsapp.clrrs.loc:9100",
    "c111ecqgrsapp.clrrs.loc:9100",
    "c112rrwgrsapp.clrrs.loc:9100",
    "c112vhugrsapp.clrrs.loc:9100",
    "c114wtegrsapp.clrrs.loc:9100",
    "c114xccgrsapp.clrrs.loc:9100",
    "c115fscgrsapp.clrrs.loc:9100",
    "c118bzhgrsapp.clrrs.loc:9100",
    "c118evcgrsapp.clrrs.loc:9100",
    "c120bhtgrsapp.clrrs.loc:9100",
    "c125cxwotwsvc.clrrs.loc:9100",
    "c128cftgrsapp.clrrs.loc:9100",
    "c132pobgrsapp.clrrs.loc:9100",
    "c133nchgrsapp.clrrs.loc:9100",
    "c133nmxgrsapp.clrrs.loc:9100",
    "c133orsgrsapp.clrrs.loc:9100",
    "c134iuhgrsapp.clrrs.loc:9100",
    "c140hycgrsapp.clrrs.loc:9100",
    "c145bsxgrsapp.clrrs.loc:9100",
    "c148ybbgrsapp.clrrs.loc:9100",
    "c150txogrsapp.clrrs.loc:9100",
    "c152dlcgrsapp.clrrs.loc:9100",
    "c154kjhgrsapp.clrrs.loc:9100",
    "c154wlagrsapp.clrrs.loc:9100",
    "c157fjpgrsapp.clrrs.loc:9100",
    "c164xaugrsapp.clrrs.loc:9100",
    "c167shbgrsapp.clrrs.loc:9100",
    "c168oibgrsapp.clrrs.loc:9100",
    "c168tpugrsapp.clrrs.loc:9100",
    "c170fgcgrsapp.clrrs.loc:9100",
    "c171avwgrsapp.clrrs.loc:9100",
    "c172mpdgrsapp.clrrs.loc:9100",
    "c175ejtgrsapp.clrrs.loc:9100",
    "c175thvotwsvc.clrrs.loc:9100",
    "c178utagrsapp.clrrs.loc:9100",
    "c183jvzotwsvc.clrrs.loc:9100",
    "c184ulagrsapp.clrrs.loc:9100",
    "c186niwgrsapp.clrrs.loc:9100",
    "c187todgrsapp.clrrs.loc:9100",
    "c188tlqgrsapp.clrrs.loc:9100",
    "c202gadgrsapp.clrrs.loc:9100",
    "c204oddgrsapp.clrrs.loc:9100",
    "c206kvnotwsvc.clrrs.loc:9100",
    "c207kvtgrsapp.clrrs.loc:9100",
    "c208kkvgrsapp.clrrs.loc:9100",
    "c210cnhgrsapp.clrrs.loc:9100",
    "c210gicgrsapp.clrrs.loc:9100",
    "c211mwugrsapp.clrrs.loc:9100",
    "c212ljbgrsapp.clrrs.loc:9100",
    "c214ogwgrsapp.clrrs.loc:9100",
    "c215atrgrsapp.clrrs.loc:9100",
    "c217hbtgrsapp.clrrs.loc:9100",
    "c217onjgrsapp.clrrs.loc:9100",
    "c221guqgrsapp.clrrs.loc:9100",
    "c222vuwgrsapp.clrrs.loc:9100",
    "c225qxvgrsapp.clrrs.loc:9100",
    "c226yqogrsapp.clrrs.loc:9100",
    "c233vahgrsapp.clrrs.loc:9100",
    "c235awggrsapp.clrrs.loc:9100",
    "c242knugrsapp.clrrs.loc:9100",
    "c243bwigrsapp.clrrs.loc:9100",
    "c247dfvgrsapp.clrrs.loc:9100",
    "c247kmxgrsapp.clrrs.loc:9100",
    "c248bhtgrsapp.clrrs.loc:9100",
    "c250antgrsapp.clrrs.loc:9100",
    "c252nzvgrsapp.clrrs.loc:9100",
    "c254hdhgrsapp.clrrs.loc:9100",
    "c255lfzgrsapp.clrrs.loc:9100",
    "c255xylgrsapp.clrrs.loc:9100",
    "c256fojgrsapp.clrrs.loc:9100",
    "c258hjngrsapp.clrrs.loc:9100",
    "c261pwvgrsapp.clrrs.loc:9100",
    "c262euggrsapp.clrrs.loc:9100",
    "c263oyfgrsapp.clrrs.loc:9100",
    "c266unngrsapp.clrrs.loc:9100",
    "c268pjrgrsapp.clrrs.loc:9100",
    "c270qppgrsapp.clrrs.loc:9100",
    "c271ifxgrsapp.clrrs.loc:9100",
    "c273uelgrsapp.clrrs.loc:9100",
    "c274afegrsapp.clrrs.loc:9100",
    "c274arvgrsapp.clrrs.loc:9100",
    "c274fxdgrsapp.clrrs.loc:9100",
    "c274iwwgrsapp.clrrs.loc:9100",
    "c274ppegrsapp.clrrs.loc:9100",
    "c276csggrsapp.clrrs.loc:9100",
    "c276vdqgrsapp.clrrs.loc:9100",
    "c277tsngrsapp.clrrs.loc:9100",
    "c277zjlgrsapp.clrrs.loc:9100",
    "c280myzgrsapp.clrrs.loc:9100",
    "c281yalgrsapp.clrrs.loc:9100",
    "c282uaigrsapp.clrrs.loc:9100",
    "c284goxgrsapp.clrrs.loc:9100",
    "c285spygrsapp.clrrs.loc:9100",
    "c286trggrsapp.clrrs.loc:9100",
    "c286wmhgrsapp.clrrs.loc:9100",
    "c288fflgrsapp.clrrs.loc:9100",
    "c303nkhgrsapp.clrrs.loc:9100",
    "c303oykgrsapp.clrrs.loc:9100",
    "c304qpggrsapp.clrrs.loc:9100",
    "c306twsgrsapp.clrrs.loc:9100",
    "c307iyvgrsapp.clrrs.loc:9100",
    "c308dxygrsapp.clrrs.loc:9100",
    "c314igjgrsapp.clrrs.loc:9100",
    "c314wwmgrsapp.clrrs.loc:9100",
    "c315ofpgrsapp.clrrs.loc:9100",
    "c318bdxgrsapp.clrrs.loc:9100",
    "c324bpvgrsapp.clrrs.loc:9100",
    "c332rybgrsapp.clrrs.loc:9100",
    "c332wmbgrsapp.clrrs.loc:9100",
    "c333qrcgrsapp.clrrs.loc:9100",
    "c334mejgrsapp.clrrs.loc:9100",
    "c340rlhgrsapp.clrrs.loc:9100",
    "c343uxjgrsapp.clrrs.loc:9100",
    "c345hyhgrsapp.clrrs.loc:9100",
    "c347ulugrsapp.clrrs.loc:9100",
    "c348ftogrsapp.clrrs.loc:9100",
    "c352slqgrsapp.clrrs.loc:9100",
    "c352wbpgrsapp.clrrs.loc:9100",
    "c352xzogrsapp.clrrs.loc:9100",
    "c353bahgrsapp.clrrs.loc:9100",
    "c353towgrsapp.clrrs.loc:9100",
    "c354etegrsapp.clrrs.loc:9100",
    "c354qllgrsapp.clrrs.loc:9100",
    "c355csbgrsapp.clrrs.loc:9100",
    "c355jevgrsapp.clrrs.loc:9100",
    "c355oyngrsapp.clrrs.loc:9100",
    "c357hiugrsapp.clrrs.loc:9100",
    "c361ddfgrsapp.clrrs.loc:9100",
    "c361zicgrsapp.clrrs.loc:9100",
    "c366tnlgrsapp.clrrs.loc:9100",
    "c367uscgrsapp.clrrs.loc:9100",
    "c368umwgrsapp.clrrs.loc:9100",
    "c371gocgrsapp.clrrs.loc:9100",
    "c371ondgrsapp.clrrs.loc:9100",
    "c373agvgrsapp.clrrs.loc:9100",
    "c378pkjgrsapp.clrrs.loc:9100",
    "c382nxogrsapp.clrrs.loc:9100",
    "c383ohdgrsapp.clrrs.loc:9100",
    "c384rzegrsapp.clrrs.loc:9100",
    "c386doqgrsapp.clrrs.loc:9100",
    "c386owjgrsapp.clrrs.loc:9100",
    "c401eyagrsapp.clrrs.loc:9100",
    "c401sktgrsapp.clrrs.loc:9100",
    "c403difgrsapp.clrrs.loc:9100",
    "c403gpggrsapp.clrrs.loc:9100",
    "c404fuzgrsapp.clrrs.loc:9100",
    "c405lxrgrsapp.clrrs.loc:9100",
    "c405wxbgrsapp.clrrs.loc:9100",
    "c406akhgrsapp.clrrs.loc:9100",
    "c411nnkgrsapp.clrrs.loc:9100",
    "c412leggrsapp.clrrs.loc:9100",
    "c412spqgrsapp.clrrs.loc:9100",
    "c412tuzgrsapp.clrrs.loc:9100",
    "c415dpdgrsapp.clrrs.loc:9100",
    "c416zoegrsapp.clrrs.loc:9100",
    "c420cqqotwsvc.clrrs.loc:9100",
    "c421lxfgrsapp.clrrs.loc:9100",
    "c422ofhgrsapp.clrrs.loc:9100",
    "c423iclgrsapp.clrrs.loc:9100",
    "c424foxgrsapp.clrrs.loc:9100",
    "c427ihwgrsapp.clrrs.loc:9100",
    "c427tjxgrsapp.clrrs.loc:9100",
    "c430rtagrsapp.clrrs.loc:9100",
    "c430ruugrsapp.clrrs.loc:9100",
    "c431yvigrsapp.clrrs.loc:9100",
    "c433fsfgrsapp.clrrs.loc:9100",
    "c433swpgrsapp.clrrs.loc:9100",
    "c441tspgrsapp.clrrs.loc:9100",
    "c442fgmotwsvc.clrrs.loc:9100",
    "c446ylpgrsapp.clrrs.loc:9100",
    "c450fwlgrsapp.clrrs.loc:9100",
    "c451dzggrsapp.clrrs.loc:9100",
    "c451qwlgrsapp.clrrs.loc:9100",
    "c451tmxgrsapp.clrrs.loc:9100",
    "c456azhgrsapp.clrrs.loc:9100",
    "c457ljsgrsapp.clrrs.loc:9100",
    "c458cbwgrsapp.clrrs.loc:9100",
    "c458cregrsapp.clrrs.loc:9100",
    "c461drdgrsapp.clrrs.loc:9100",
    "c464ilzgrsapp.clrrs.loc:9100",
    "c466wiqgrsapp.clrrs.loc:9100",
    "c468ojrgrsapp.clrrs.loc:9100",
    "c468xxogrsapp.clrrs.loc:9100",
    "c468ybtgrsapp.clrrs.loc:9100",
    "c470dmmotwsvc.clrrs.loc:9100",
    "c471ptegrsapp.clrrs.loc:9100",
    "c473ysqgrsapp.clrrs.loc:9100",
    "c474kragrsapp.clrrs.loc:9100",
    "c475phegrsapp.clrrs.loc:9100",
    "c475wbggrsapp.clrrs.loc:9100",
    "c477oykgrsapp.clrrs.loc:9100",
    "c478lofgrsapp.clrrs.loc:9100",
    "c480wengrsapp.clrrs.loc:9100",
    "c481ftzgrsapp.clrrs.loc:9100",
    "c483waxgrsapp.clrrs.loc:9100",
    "c484mdpgrsapp.clrrs.loc:9100",
    "c495jhaotwsvc.clrrs.loc:9100",
    "c500knsgrsapp.clrrs.loc:9100",
    "c503hjvgrsapp.clrrs.loc:9100",
    "c504jlrgrsapp.clrrs.loc:9100",
    "c505nqagrsapp.clrrs.loc:9100",
    "c506auhgrsapp.clrrs.loc:9100",
    "c511zxgotwsvc.clrrs.loc:9100",
    "c512hgsgrsapp.clrrs.loc:9100",
    "c514oaagrsapp.clrrs.loc:9100",
    "c514qaqgrsapp.clrrs.loc:9100",
    "c515pfkgrsapp.clrrs.loc:9100",
    "c522beggrsapp.clrrs.loc:9100",
    "c522xwlgrsapp.clrrs.loc:9100",
    "c523cwogrsapp.clrrs.loc:9100",
    "c524npfgrsapp.clrrs.loc:9100",
    "c525dnngrsapp.clrrs.loc:9100",
    "c527bchgrsapp.clrrs.loc:9100",
    "c527fvmgrsapp.clrrs.loc:9100",
    "c532egggrsapp.clrrs.loc:9100",
    "c532gkmgrsapp.clrrs.loc:9100",
    "c532obxgrsapp.clrrs.loc:9100",
    "c533zpfgrsapp.clrrs.loc:9100",
    "c534hgvgrsapp.clrrs.loc:9100",
    "c534lrdgrsapp.clrrs.loc:9100",
    "c534ttjgrsapp.clrrs.loc:9100",
    "c535biwgrsapp.clrrs.loc:9100",
    "c535gzwgrsapp.clrrs.loc:9100",
    "c535ogegrsapp.clrrs.loc:9100",
    "c543dfmgrsapp.clrrs.loc:9100",
    "c543urpgrsapp.clrrs.loc:9100",
    "c547irrgrsapp.clrrs.loc:9100",
    "c551ilngrsapp.clrrs.loc:9100",
    "c551sasgrsapp.clrrs.loc:9100",
    "c556uoqgrsapp.clrrs.loc:9100",
    "c556wrkgrsapp.clrrs.loc:9100",
    "c557tsmgrsapp.clrrs.loc:9100",
    "c565lkegrsapp.clrrs.loc:9100",
    "c571pnagrsapp.clrrs.loc:9100",
    "c573mssgrsapp.clrrs.loc:9100",
    "c573vdrotwsvc.clrrs.loc:9100",
    "c574vqpgrsapp.clrrs.loc:9100",
    "c575jrqgrsapp.clrrs.loc:9100",
    "c577vzwgrsapp.clrrs.loc:9100",
    "c581qwwotwsvc.clrrs.loc:9100",
    "c581txxgrsapp.clrrs.loc:9100",
    "c584xaigrsapp.clrrs.loc:9100",
    "c588hgzgrsapp.clrrs.loc:9100",
    "c588ugxgrsapp.clrrs.loc:9100",
    "c600yjngrsapp.clrrs.loc:9100",
    "c602ruegrsapp.clrrs.loc:9100",
    "c603jqjgrsapp.clrrs.loc:9100",
    "c608pxhgrsapp.clrrs.loc:9100",
    "c612baagrsapp.clrrs.loc:9100",
    "c616mvsgrsapp.clrrs.loc:9100",
    "c617hovgrsapp.clrrs.loc:9100",
    "c617mwigrsapp.clrrs.loc:9100",
    "c618autgrsapp.clrrs.loc:9100",
    "c620wtzgrsapp.clrrs.loc:9100",
    "c623owegrsapp.clrrs.loc:9100",
    "c624lyugrsapp.clrrs.loc:9100",
    "c628aohgrsapp.clrrs.loc:9100",
    "c633hdtgrsapp.clrrs.loc:9100",
    "c634ldrgrsapp.clrrs.loc:9100",
    "c634qmdgrsapp.clrrs.loc:9100",
    "c634uxrotwsvc.clrrs.loc:9100",
    "c634vwogrsapp.clrrs.loc:9100",
    "c641drxgrsapp.clrrs.loc:9100",
    "c641nbhgrsapp.clrrs.loc:9100",
    "c642dkygrsapp.clrrs.loc:9100",
    "c646bjcgrsapp.clrrs.loc:9100",
    "c648omcgrsapp.clrrs.loc:9100",
    "c651oowgrsapp.clrrs.loc:9100",
    "c654xxmgrsapp.clrrs.loc:9100",
    "c655qpngrsapp.clrrs.loc:9100",
    "c655wlogrsapp.clrrs.loc:9100",
    "c660qjhgrsapp.clrrs.loc:9100",
    "c660vpigrsapp.clrrs.loc:9100",
    "c661yxcotwsvc.clrrs.loc:9100",
    "c664yqtgrsapp.clrrs.loc:9100",
    "c670kgbotwsvc.clrrs.loc:9100",
    "c671xgigrsapp.clrrs.loc:9100",
    "c673jnxgrsapp.clrrs.loc:9100",
    "c674aevgrsapp.clrrs.loc:9100",
    "c677mqmgrsapp.clrrs.loc:9100",
    "c681rwtgrsapp.clrrs.loc:9100",
    "c681wopgrsapp.clrrs.loc:9100",
    "c685bjygrsapp.clrrs.loc:9100",
    "c686mtkotwsvc.clrrs.loc:9100",
    "c687crhgrsapp.clrrs.loc:9100",
    "c702fuqgrsapp.clrrs.loc:9100",
    "c703zgjgrsapp.clrrs.loc:9100",
    "c704kcxgrsapp.clrrs.loc:9100",
    "c704ppzgrsapp.clrrs.loc:9100",
    "c705fdjgrsapp.clrrs.loc:9100",
    "c705xqdgrsapp.clrrs.loc:9100",
    "c710zcagrsapp.clrrs.loc:9100",
    "c713axdgrsapp.clrrs.loc:9100",
    "c713bzdgrsapp.clrrs.loc:9100",
    "c717gnbgrsapp.clrrs.loc:9100",
    "c717irbgrsapp.clrrs.loc:9100",
    "c719bktotwsvc.clrrs.loc:9100",
    "c721qiigrsapp.clrrs.loc:9100",
    "c722vskgrsapp.clrrs.loc:9100",
    "c723ixggrsapp.clrrs.loc:9100",
    "c724lsugrsapp.clrrs.loc:9100",
    "c724orrgrsapp.clrrs.loc:9100",
    "c726cqigrsapp.clrrs.loc:9100",
    "c726szsgrsapp.clrrs.loc:9100",
    "c728nzcgrsapp.clrrs.loc:9100",
    "c730lgggrsapp.clrrs.loc:9100",
    "c731ezwgrsapp.clrrs.loc:9100",
    "c731ikngrsapp.clrrs.loc:9100",
    "c732ndigrsapp.clrrs.loc:9100",
    "c732qyqgrsapp.clrrs.loc:9100",
    "c733stvgrsapp.clrrs.loc:9100",
    "c734owqgrsapp.clrrs.loc:9100",
    "c741mzjgrsapp.clrrs.loc:9100",
    "c741qunotwsvc.clrrs.loc:9100",
    "c742vqjgrsapp.clrrs.loc:9100",
    "c745tuzgrsapp.clrrs.loc:9100",
    "c750fgjgrsapp.clrrs.loc:9100",
    "c750udhgrsapp.clrrs.loc:9100",
    "c750vuzgrsapp.clrrs.loc:9100",
    "c752ultgrsapp.clrrs.loc:9100",
    "c752ykfgrsapp.clrrs.loc:9100",
    "c755nnwgrsapp.clrrs.loc:9100",
    "c755tybotwsvc.clrrs.loc:9100",
    "c757dzegrsapp.clrrs.loc:9100",
    "c785qjdotwsvc.clrrs.loc:9100",
    "c805rmzotwsvc.clrrs.loc:9100",
    "c826umyotwsvc.clrrs.loc:9100",
    "c830rbuotwsvc.clrrs.loc:9100",
    "c877qxmotwsvc.clrrs.loc:9100",
    "c896ehjgrsapp.clrrs.loc:9100",
    "c897rjxgrsapp.clrrs.loc:9100",
    "c922thfgrsapp.clrrs.loc:9100",
    "c924wwmotwsvc.clrrs.loc:9100",
    "c936vscotwsvc.clrrs.loc:9100",
    "c938kuzgrsapp.clrrs.loc:9100",
    "c963kvggrsapp.clrrs.loc:9100",
    "c981xqvotwsvc.clrrs.loc:9100",
    "c995cnfotwsvc.clrrs.loc:9100"
)

$serverConfig["prod"]["pdfsvc"] = @(
    "c050kaygrsapp.clrrs.loc:9004",
    "c154itigrsapp.clrrs.loc:9004",
    "c210daogrsapp.clrrs.loc:9004",
    "c223svwgrsapp.clrrs.loc:9004",
    "c247eghgrsapp.clrrs.loc:9004",
    "c270ynsgrsapp.clrrs.loc:9004",
    "c578dtsgrsapp.clrrs.loc:9004",
    "c583ehtgrsapp.clrrs.loc:9004",
    "c583waagrsapp.clrrs.loc:9004",
    "c611lsvgrsapp.clrrs.loc:9004",
    "c625oobgrsapp.clrrs.loc:9004",
    "c699jdpgrsapp.clrrs.loc:9004",
    "c701dnagrsapp.clrrs.loc:9004",
    "c705ncagrsapp.clrrs.loc:9004",
    "c711cxbgrsapp.clrrs.loc:9004",
    "c713kwigrsapp.clrrs.loc:9004",
    "c713ncagrsapp.clrrs.loc:9004",
    "c718hucgrsapp.clrrs.loc:9004",
    "c718mqsgrsapp.clrrs.loc:9004",
    "c721wesgrsapp.clrrs.loc:9004",
    "c722awxgrsapp.clrrs.loc:9004",
    "c724ehxgrsapp.clrrs.loc:9004",
    "c725nkegrsapp.clrrs.loc:9004",
    "c730tmtgrsapp.clrrs.loc:9004",
    "c730wzxgrsapp.clrrs.loc:9004",
    "c732dnegrsapp.clrrs.loc:9004",
    "c732zlzgrsapp.clrrs.loc:9004",
    "c736adegrsapp.clrrs.loc:9004",
    "c736fujgrsapp.clrrs.loc:9004",
    "c737pdbgrsapp.clrrs.loc:9004",
    "c738bwxgrsapp.clrrs.loc:9004",
    "c739jnwgrsapp.clrrs.loc:9004",
    "c748kwpgrsapp.clrrs.loc:9004",
    "c750bfygrsapp.clrrs.loc:9004",
    "c750pdbgrsapp.clrrs.loc:9004",
    "c750xmzgrsapp.clrrs.loc:9004",
    "c752bxjgrsapp.clrrs.loc:9004",
    "c759ewkgrsapp.clrrs.loc:9004",
    "c765ezagrsapp.clrrs.loc:9004",
    "c765xeugrsapp.clrrs.loc:9004",
    "c766pgwgrsapp.clrrs.loc:9004",
    "c770doygrsapp.clrrs.loc:9004",
    "c772nbmgrsapp.clrrs.loc:9004",
    "c774ppbgrsapp.clrrs.loc:9004",
    "c775omdgrsapp.clrrs.loc:9004",
    "c775ydcgrsapp.clrrs.loc:9004",
    "c776gtegrsapp.clrrs.loc:9004",
    "c777xekgrsapp.clrrs.loc:9004",
    "c778jpngrsapp.clrrs.loc:9004",
    "c780wmpgrsapp.clrrs.loc:9004",
    "c784mgzgrsapp.clrrs.loc:9004",
    "c785dqugrsapp.clrrs.loc:9004",
    "c786lxrgrsapp.clrrs.loc:9004",
    "c787zktgrsapp.clrrs.loc:9004",
    "c788uokgrsapp.clrrs.loc:9004",
    "c793xdjfarsrv.clrrs.loc:9004",
    "c800jqogrsapp.clrrs.loc:9004",
    "c801gvjgrsapp.clrrs.loc:9004",
    "c802upqgrsapp.clrrs.loc:9004",
    "c804rkegrsapp.clrrs.loc:9004",
    "c804vrbgrsapp.clrrs.loc:9004",
    "c805pzogrsapp.clrrs.loc:9004",
    "c807sbogrsapp.clrrs.loc:9004",
    "c810rrdgrsapp.clrrs.loc:9004",
    "c810xdcgrsapp.clrrs.loc:9004",
    "c811jcogrsapp.clrrs.loc:9004",
    "c812zsigrsapp.clrrs.loc:9004",
    "c813fchgrsapp.clrrs.loc:9004",
    "c814haxgrsapp.clrrs.loc:9004",
    "c815bhtgrsapp.clrrs.loc:9004",
    "c817ypbgrsapp.clrrs.loc:9004",
    "c822dxpgrsapp.clrrs.loc:9004",
    "c822dxxgrsapp.clrrs.loc:9004",
    "c824vgvgrsapp.clrrs.loc:9004",
    "c825xyvgrsapp.clrrs.loc:9004",
    "c827hxegrsapp.clrrs.loc:9004",
    "c829rfdgrsapp.clrrs.loc:9004",
    "c830cafgrsapp.clrrs.loc:9004",
    "c831iwwgrsapp.clrrs.loc:9004",
    "c833ffegrsapp.clrrs.loc:9004",
    "c833mytgrsapp.clrrs.loc:9004",
    "c841kpygrsapp.clrrs.loc:9004",
    "c841zgvgrsapp.clrrs.loc:9004",
    "c843uaxgrsapp.clrrs.loc:9004",
    "c845uvlgrsapp.clrrs.loc:9004",
    "c846gyugrsapp.clrrs.loc:9004",
    "c846xcvgrsapp.clrrs.loc:9004",
    "c846zndgrsapp.clrrs.loc:9004",
    "c847hiwgrsapp.clrrs.loc:9004",
    "c847iwlgrsapp.clrrs.loc:9004",
    "c848ciagrsapp.clrrs.loc:9004",
    "c852kjrgrsapp.clrrs.loc:9004",
    "c853pdigrsapp.clrrs.loc:9004",
    "c854kysgrsapp.clrrs.loc:9004",
    "c854umdgrsapp.clrrs.loc:9004",
    "c854uwrgrsapp.clrrs.loc:9004",
    "c856zzngrsapp.clrrs.loc:9004",
    "c862dghgrsapp.clrrs.loc:9004",
    "c862etpgrsapp.clrrs.loc:9004",
    "c864fbmgrsapp.clrrs.loc:9004",
    "c864wrrgrsapp.clrrs.loc:9004",
    "c867tnygrsapp.clrrs.loc:9004",
    "c870wrrgrsapp.clrrs.loc:9004",
    "c871knugrsapp.clrrs.loc:9004",
    "c873nezgrsapp.clrrs.loc:9004",
    "c875iwrgrsapp.clrrs.loc:9004",
    "c875uvmgrsapp.clrrs.loc:9004",
    "c875wjcgrsapp.clrrs.loc:9004",
    "c875ziigrsapp.clrrs.loc:9004",
    "c877pmlgrsapp.clrrs.loc:9004",
    "c877xgpgrsapp.clrrs.loc:9004",
    "c880sgbgrsapp.clrrs.loc:9004",
    "c881eimgrsapp.clrrs.loc:9004",
    "c881phjgrsapp.clrrs.loc:9004",
    "c884jqrgrsapp.clrrs.loc:9004",
    "c884pukgrsapp.clrrs.loc:9004",
    "c886dsggrsapp.clrrs.loc:9004",
    "c888teigrsapp.clrrs.loc:9004",
    "c891msxgrsapp.clrrs.loc:9004",
    "c892drrgrsapp.clrrs.loc:9004",
    "c892dzygrsapp.clrrs.loc:9004",
    "c898gswgrsapp.clrrs.loc:9004",
    "c901nzhgrsapp.clrrs.loc:9004",
    "c903gdhgrsapp.clrrs.loc:9004",
    "c904bvfgrsapp.clrrs.loc:9004",
    "c904fjvgrsapp.clrrs.loc:9004",
    "c905thfgrsapp.clrrs.loc:9004",
    "c931yssgrsapp.clrrs.loc:9004",
    "c938xhagrsapp.clrrs.loc:9004",
    "c958xcmgrsapp.clrrs.loc:9004"
)

# $serverConfig["prod"]["pdfsvc"] = @(
#     # "c154itigrsapp.clrrs.loc:9004",
#     # "c210daogrsapp.clrrs.loc:9004",
#     # "c223svwgrsapp.clrrs.loc:9004",
#     # "c247eghgrsapp.clrrs.loc:9004",
#     # "c270ynsgrsapp.clrrs.loc:9004",
#     # "c578dtsgrsapp.clrrs.loc:9004",
#     # "c050kaygrsapp.clrrs.loc:9004",
#     # "c611lsvgrsapp.clrrs.loc:9004"
#     # "c777xekgrsapp.clrrs.loc:9004"
#     # "c154itigrsapp.clrrs.loc:9004",
#     # "c210daogrsapp.clrrs.loc:9004",
#     # "c223svwgrsapp.clrrs.loc:9004",
#     # "c625oobgrsapp.clrrs.loc:9004",
#     # "c713kwigrsapp.clrrs.loc:9004",
#     # "c732zlzgrsapp.clrrs.loc:9004",
#     # "c765ezagrsapp.clrrs.loc:9004"
#     # "c625oobgrsapp.clrrs.loc:9004",
#     # "c713kwigrsapp.clrrs.loc:9004",
#     # "c732zlzgrsapp.clrrs.loc:9004",
#     # "c765ezagrsapp.clrrs.loc:9004",
#     "c765xeugrsapp.clrrs.loc:9004",
#     "c766pgwgrsapp.clrrs.loc:9004",
#     "c770doygrsapp.clrrs.loc:9004",
#     "c772nbmgrsapp.clrrs.loc:9004",
#     # "c775omdgrsapp.clrrs.loc:9004",
#     # "c775ydcgrsapp.clrrs.loc:9004",
#     # "c776gtegrsapp.clrrs.loc:9004",
#     # "c777xekgrsapp.clrrs.loc:9004",
#     "c778jpngrsapp.clrrs.loc:9004",
#     "c780wmpgrsapp.clrrs.loc:9004",
#     "c784mgzgrsapp.clrrs.loc:9004",
#     "c785dqugrsapp.clrrs.loc:9004",
#     "c786lxrgrsapp.clrrs.loc:9004",
#     "c787zktgrsapp.clrrs.loc:9004",
#     "c788uokgrsapp.clrrs.loc:9004",
#     "c800jqogrsapp.clrrs.loc:9004",
#     # "c801gvjgrsapp.clrrs.loc:9004",
#     "c802upqgrsapp.clrrs.loc:9004",
#     "c804rkegrsapp.clrrs.loc:9004",
#     "c804vrbgrsapp.clrrs.loc:9004",
#     "c805pzogrsapp.clrrs.loc:9004",
#     "c807sbogrsapp.clrrs.loc:9004",
#     "c810rrdgrsapp.clrrs.loc:9004",
#     "c811jcogrsapp.clrrs.loc:9004",
#     # "c812zsigrsapp.clrrs.loc:9004",
#     # "c813fchgrsapp.clrrs.loc:9004",
#     "c814haxgrsapp.clrrs.loc:9004",
#     # "c815bhtgrsapp.clrrs.loc:9004",
#     # "c822dxpgrsapp.clrrs.loc:9004",
#     # "c822dxxgrsapp.clrrs.loc:9004",
#     # "c824vgvgrsapp.clrrs.loc:9004",
#     "c827hxegrsapp.clrrs.loc:9004",
#     "c830cafgrsapp.clrrs.loc:9004",
#     # "c831iwwgrsapp.clrrs.loc:9004",
#     # "c833ffegrsapp.clrrs.loc:9004",
#     "c833mytgrsapp.clrrs.loc:9004",
#     "c841kpygrsapp.clrrs.loc:9004",
#     "c843uaxgrsapp.clrrs.loc:9004",
#     # "c845uvlgrsapp.clrrs.loc:9004",
#     # "c846gyugrsapp.clrrs.loc:9004",
#     # "c846xcvgrsapp.clrrs.loc:9004",
#     # "c846zndgrsapp.clrrs.loc:9004",
#     "c847hiwgrsapp.clrrs.loc:9004",
#     "c847iwlgrsapp.clrrs.loc:9004",
#     "c848ciagrsapp.clrrs.loc:9004",
#     "c852kjrgrsapp.clrrs.loc:9004",
#     "c853pdigrsapp.clrrs.loc:9004",
#     "c854kysgrsapp.clrrs.loc:9004",
#     "c854umdgrsapp.clrrs.loc:9004",
#     "c854uwrgrsapp.clrrs.loc:9004",
#     # "c856zzngrsapp.clrrs.loc:9004",
#     # "c862etpgrsapp.clrrs.loc:9004",
#     "c864fbmgrsapp.clrrs.loc:9004",
#     "c867tnygrsapp.clrrs.loc:9004",
#     # "c871knugrsapp.clrrs.loc:9004",
#     # "c873nezgrsapp.clrrs.loc:9004",
#     "c875iwrgrsapp.clrrs.loc:9004",
#     "c875uvmgrsapp.clrrs.loc:9004",
#     "c875wjcgrsapp.clrrs.loc:9004",
#     "c875ziigrsapp.clrrs.loc:9004",
#     "c877pmlgrsapp.clrrs.loc:9004",
#     "c877xgpgrsapp.clrrs.loc:9004",
#     # "c880sgbgrsapp.clrrs.loc:9004",
#     "c881eimgrsapp.clrrs.loc:9004",
#     # "c881phjgrsapp.clrrs.loc:9004",
#     "c884jqrgrsapp.clrrs.loc:9004",
#     "c888teigrsapp.clrrs.loc:9004"
# )

$timeoutSecs = 5

foreach ($serverTypeListItem in $serverTypeList) {
    if (-not $outputIpAddresses) {
        Write-Host "$env $serverTypeListItem"
    }

    [array]$servers = @()
    if ($serverTypeListItem -eq "valsvc") {
        $servers = $serverConfig[$env]["svc"]
    }
    else {
        $servers = $serverConfig[$env][$serverTypeListItem]
    }

    $colorList = [System.Collections.Generic.List[System.ConsoleColor]]@(
        [System.ConsoleColor]::Blue,
        [System.ConsoleColor]::Magenta,
        [System.ConsoleColor]::Cyan,
        [System.ConsoleColor]::Yellow,
        [System.ConsoleColor]::White)

    $versionColors = @{ }
    $serverNumber = 0

    $serverIpAddresses = [System.Collections.Generic.List[string]]@()

    foreach ($server in $servers | Sort-Object) {
        $healthStatus = "unknown"
        $statusColor = [System.ConsoleColor]::Yellow
        $serverName = $server.Split(".")[0]
        [array]$serverParts = $server.Split(":")
        $ipaddress = ([System.Net.Dns]::GetHostAddresses($serverParts[0])).IPAddressToString
        if ($outputIpAddresses) {
            $serverIpAddresses.Add($ipaddress)
            continue
        }

        $port = 80
        if ($serverParts.Length -gt 1) {
            $port = $serverParts[1]
        }

        try {
            [int] $TimeTaken = 0
            $versionInfo = ""
            $statusInfo = ""
            $Start = 0
            $End = 0
            if ($serverTypeListItem -eq "valsvc") {
                # http://10.202.99.99:9100/healthcheck/validationservice/version
                $versionInfo = (Invoke-WebRequest -Uri "http://$($ipaddress):$($port)/healthcheck/validationservice/version" -TimeoutSec $timeoutSecs).Content.replace("`r`n", "")
                $Start = Get-Date
                $statusInfo = (Invoke-WebRequest -Uri "http://$($ipaddress):$($port)/healthcheck/validationservice" -TimeoutSec $timeoutSecs).Content.replace("`r`n", "").ToUpper()
                $End = Get-Date
                $TimeTaken = ($End - $Start).TotalMilliseconds 
                $healthStatus = "pass"
                $statusColor = [System.ConsoleColor]::Green

                if ($statusInfo -ne "HEALTHY") {
                    $healthStatus = "fail"
                    $statusColor = [System.ConsoleColor]::Red
                }
            }
            else {
                $versionInfo = (Invoke-WebRequest -Uri "http://$($ipaddress):$($port)/healthcheck/version" -TimeoutSec $timeoutSecs).Content.replace("`r`n", "")
                $Start = Get-Date
                $statusInfo = (Invoke-WebRequest -Uri "http://$($ipaddress):$($port)/healthcheck/status" -TimeoutSec $timeoutSecs).Content.replace("`r`n", "")
                $End = Get-Date
                $TimeTaken = ($End - $Start).TotalMilliseconds 
                $healthStatus = "pass"
                $statusColor = [System.ConsoleColor]::Green
    
                if ($statusInfo -ne "1") {
                    $healthStatus = "fail"
                    $statusColor = [System.ConsoleColor]::Red
                }
            }
        
        }
        catch {
            $healthStatus = "exception"
            $statusColor = [System.ConsoleColor]::Red
            $TimeTaken = 0
            if ($Start) {
                $TimeTaken = ($(Get-Date) - $Start).TotalMilliseconds 
            }
        }

        $timeColor = [System.ConsoleColor]::Green
        if ($TimeTaken -ge 1000) {
            $timeColor = [System.ConsoleColor]::Yellow
        }
    
        if ($TimeTaken -gt ($timeoutSecs * 1000)) {
            $healthStatus = "timeout"
            $statusColor = [System.ConsoleColor]::Blue
            $timeColor = [System.ConsoleColor]::Red
        }

        if ($omitGood -and $healthStatus -eq "pass") {
            continue
        }

        if ($timeoutOnly -and $healthStatus -ne "timeout") {
            continue
        }

        if ($omitVersion -eq $versionInfo -and $healthStatus -ne "exception") {
            continue
        }

        if ($versionInfo) {
            if (-not $versionColors.ContainsKey($versionInfo)) {
                $versionColors[$versionInfo] = $colorList[0]
                $colorList.RemoveAt(0)
            }
        }

        $serverNumber++
        Write-Host "$serverNumber`t" -ForegroundColor White -NoNewline
        Write-Host "$($serverName.ToUpper())" -ForegroundColor White -NoNewline
        Write-Host "`t$ipaddress" -ForegroundColor Gray -NoNewline
        if ($versionInfo) {
            Write-Host "`t$versionInfo" -ForegroundColor $versionColors[$versionInfo] -NoNewline
        }

        if ($healthStatus -eq "exception") {
            Write-Host "`t$healthStatus" -ForegroundColor $statusColor -NoNewline
        }
        else {
            Write-Host "`t$healthStatus" -ForegroundColor $statusColor -NoNewline
            Write-Host "`t($TimeTaken ms)" -ForegroundColor $timeColor -NoNewline
        }

        if ($port -eq '9004' -and $healthStatus -ne "exception") {
            $onlineStatus = "offline"
            $onlineStatusColor = "red"
            $isOnline = '0'
            try {
                $isOnline = (Invoke-WebRequest -Uri "http://$($ipaddress):$($port)/healthcheck/online" -TimeoutSec $timeoutSecs).Content.replace("`r`n", "")
            }
            catch {
                $healthStatus = "exception"
            }

            if ($isOnline -eq '1') {
                $onlineStatus = "online"
                $onlineStatusColor = "green"
            }

            Write-Host "`t$($onlineStatus)" -ForegroundColor $onlineStatusColor -NoNewline
        }

        Write-Host
    }

    if ($outputIpAddresses) {
        return $serverIpAddresses | Sort-Object
    }

    Write-Host
}

