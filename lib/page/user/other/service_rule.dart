import 'package:flutter/material.dart';
import 'package:flutter_app/assets/images.dart';
import 'package:flutter_app/common/config/address.dart';
import 'package:flutter_app/widget/common_widget/common_widget.dart';
import 'package:flutter_app/widget/full_bg.dart';
import 'package:flutter_base/utils/dimens.dart';

///服务条款
class ServiceRule extends StatelessWidget {
  final String title;
  final int serviceType;

  ServiceRule({Key key, this.title, this.serviceType = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FullBg(
        child: Scaffold(
      appBar: getCommonAppBar(title ?? ""),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 16),
            Image(
              image: AssetImage(
                AssetsImages.ICON_APP_LOGO,
              ),
              width: Dimens.pt80,
              height: Dimens.pt80,
            ),
            SizedBox(height: 8),
            Text(
              Address.landUrl ?? "",
              style: TextStyle(color: Colors.white54),
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: serviceType == 0
                  ? _buildPrivacyPolicyUI()
                  : _buildServiceRuleUI(),
            ),
          ],
        ),
      ),
    ));
  }
}

///隐私政策
Column _buildPrivacyPolicyUI() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildContentUI(
            "本隐私条款说明当您使用我们的网站、手机应用程式或其他线上产品和服务（以下统称为 「服务」 ），或者当您以其他方式与我们互动时，您的资讯将如何被收集并使用于「51乱伦」。我们可能会随时更改此隐私权条款，因此我们鼓励您在使用服务时，随时查看并了解我们最新的隐私权条款，以便帮助保护您的资讯隐私。"),
        _buildTitleUI("您所提供给我们的资讯"),
        _buildContentUI(
            "我们会收集您直接提供给我们的资讯。例如，我们会收集所有您创建帐户时的资讯，以及使用服务来发送或接收的讯息（包含通过我们的服务「51乱伦」所拍摄的照片或影片，以及通过客服或与其他方式与我们沟通时所产生的讯息。）我们可能收集的资讯包含用户名称、帐户密码、电子邮件地址、电话号码、年龄、性别以及任何您选择提供的其他资讯。" +
                "我们诚心地建议您提供您拥有版权的内容（例如讯息、照片、影片、标题）。我们无法防范他人储存您的内容（例如拍摄截图），如果您不希望有心人士储存您的某些内容，那么您不应使用 51乱伦 发送该内容。"),
        _buildTitleUI("我们在您使用服务时所收集的资讯"),
        _buildContentUI("当您使用我们的服务时，我们会自动收集您的以下资讯："),
        _buildContentUI(
            "• 使用纪录：当您通过我们的服务发送或接收讯息，我们会收集这些讯息资讯，包括时间、日期、发件人和收件人等资讯。我们还会收集您发送与接收的讯息数量，以及您较常传送讯息的朋友名单。我们也会收集您使用我们的服务时的资讯，包含您的浏览器类型、语言、使用时间、IP位址等。" +
                "\n• 装置资讯：我们会收集您使用我们的服务时使用的装置资讯，包括装置类型、操作系统和版本、" +
                "\n• 设备标识码、电话号码和行动网络资讯。此外，本服务在经过您的同意之下，可取用您装置中的电话簿和影像存储应用程式，以方便支援您在使用本服务时的功能。位置资讯：在经过您的同意之下，我们会收集有关您的装置位置资讯，以方便支援您在使用本服务时的功能。" +
                "\n• 数据追踪：我们会使用各种数据追踪技术来收集资讯，来帮助我们来改进我们的服务和您的使用体验。"),
        _buildTitleUI("我们从其他人取得的资讯"),
        _buildContentUI("除了您直接提供给我们的资讯外，我们还会从其他人那里获得有关您的资讯，包括："),
        _buildContentUI(
            "• 其他使用者：其他人可能在使用我们的服务时提供有关您的资讯。例如，如果其他使用者就您的事情与我们联系，我们可能会从他们那里收集有关您的资讯。" +
                "\n• 社群媒体：您可能会使用自己的社群媒体登入资讯（例如Facebook或twitter登入资讯）来建立和登入您的51乱伦帐号。因此您无须再记住另一组使用者名称和密码，并可通过您的社群媒体帐号与我们分享一些资讯。" +
                "\n• 其他合作伙伴：我们可能会从合作伙伴那里取得有关您的资讯，例如，51乱伦广告刊登在合作伙伴的网站和平台上。（这种情况下，他们可能会将活动成功的详细资讯传递给我们）。"),
        _buildTitleUI("我们使用您资讯"),
        _buildContentUI(
            "我们使用您资讯的主要原因是为了提供和改善我们的服务。此外，我们使用您的资讯来维护您的安全，并提供您可能感兴趣的广告。请继续阅读有关我们使用您资讯的各项原因详细说明，以及实际范例。"),
        _buildTitleUI("管理您的帐号，并提供我们的服务给您"),
        _buildContentUI("• 建立和管理您的帐号" +
            "\n• 为您提供客户支援，和回应您的要求" +
            " \n• 完成您的交易" +
            "\n• 就我们的服务（包括订单管理和计费）与您沟通" +
            "\n• 将您使用的各种装置连结起来，以便让您在所有装置上享受我们的服务，并获得一致性体验。我们通过连结装置和浏览器资料来提供一致性体验（例如当您在不同装置上登入帐号时），或使用部分或完整的IP位址、浏览器版本和有关您装置的类似资料，来辨识和连结装置。"),
        _buildTitleUI("为您提供最优的51乱伦服务"),
        _buildContentUI("• 让您注册新的51乱伦功能和app，并显示您的个人资料。" +
            "\n• 在这些新功能和app中管理您的帐号改善我们的服务和开发新服务" +
            "\n• 管理焦点团体和问卷调查" +
            "\n• 针对使用者行为进行研究和分析，以改善我们的服务和内容（例如，我们可能会决定变更外观和感觉，或什至根据使用者行为，大幅修改特定功能）" +
            "\n• 开发新功能和服务（例如，我们可能会决定根据使用者的要求，进一步建立一个以兴趣为依据的新功能）"),
        _buildTitleUI("防止、发现和打击诈欺、其他非法或未经授权的活动"),
        _buildContentUI("• 处理正在发生，或被指控的不当行为（无论是否发生在平台上）" +
            "\n• 分析资料，以更加了解这类活动并制定对策" +
            "\n• 保留诈欺活动相关资料，以防止这类活动再次发生"),
        _buildTitleUI("我们如何保护您的资讯"),
        _buildContentUI(
            "我们致力防止您的个人资讯遭未经授权的存取或变更、披露或销毁。与所有科技公司一样，尽管我们采取措施保护您的资讯，但是我们无法承诺，而且您亦不应期望，您的个人资讯会始终安全无虞。针对可能存在的漏洞和攻击，我们定期监视我们的系统，并定期审查我们的资讯收集、储存和处理做法，以更新我们的实体、技术和组织安全措施。如果我们怀疑或发现任何违反安全的行为，我们可以暂停您使用所有或部分服务，恕不另行通知。如果您认为您的帐号或资讯不再安全，请立即通知我们。"),
        _buildContentUI("儿童的隐私"),
        _buildContentUI(
            "我们的服务仅限18岁（含）以上的使用者使用。我们不允许18岁以下的使用者使用我们的平台，而且我们不会在知情的情况下收集18岁以下人士的个人资讯。如果您怀疑任何使用者的年龄低于18岁，请通过服务提供的通报机制，向我们通报此疑虑。"),
        _buildTitleUI("其他"),
        _buildTitleUI("帐户资讯"),
        _buildContentUI("您可以在App中编辑您的帐号设定，更新您的个人资讯。如您有任何问题，请在  与我们联系。"),
        _buildTitleUI("推播通知"),
        _buildContentUI(
            "51乱伦会发送推播通知或系统提醒到您的装置。您可以在您的装置设定中更改通知设定（iOS）,或者通过App更改通知设定（Android）。"),
        _buildContentUI(
            "本公司提供活动资讯通知之服务（包括但不限于以推播、简讯或电子邮件之方式不定期发送活动资讯）。若您不希望收到任何活动资讯，可随时联系本公司客服，本公司客服将协助您取消活动资讯通知之设定。"),
      ],
    );

Column _buildServiceRuleUI() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleUI("关于51乱伦"),
        _buildContentUI(
          "51乱伦是一个付费浏览的社交通讯应用服务，用户可以通过创建、发布私密照片与影片，赚取潜在的获利。这些服务条款，包含我们的隐私政策（以下统称为「条款」）是您使用51乱伦的规范。若您使用51乱伦，表示您接受并同意遵守这些规范条款。如果您不同意任一条款，或是您不满意51乱伦，我们唯一的建议是停止使用51乱伦。我们保留随时修改条款的权利。如果我们做出重大变更，我们将努力通过App或是官网张贴变更告示，或是通过任何其他合理的方式通知您。此外，我们会在更新条款后您登入51乱伦时要求您同意更新的条款（例如要求您勾选「我同意条款」的按钮）。当您表示同意并持续使用51乱伦，即表示您同意这些更新条款的规范。当您使用51乱伦时，我们与您便会通过电子通讯的方式进行沟通，此方式包含电子邮件、推播通知以及App系统讯息。您了解并同意我们提供给您的协议、通知、讯息发布等电子书面形式是符合法定要求的。您了解并同意使用51乱伦时会产生行动网路数据费用，且这些数据费用将完全由您承担。"
              "\n我们保留权力在任何时间以任何理由没有责任在有告知或无告知的情况下进行： "
              "\n（一）修改、暂停或终止51乱伦或其任何功能；"
              "\n（二）限定、限制、暂停或终止您使用51乱伦或其任何功能； "
              "\n（三）删除、屏蔽或禁止您在51乱伦中张贴的内容； "
              "\n（四）监测您使用51乱伦时是否符合遵守条款（包含您在51乱伦所发布或传送的任何内容或讯息）",
        ),
        _buildTitleUI("使用51乱伦"),
        _buildContentUI(
          "您可以让您的追踪者看到您使用51乱伦创建和发布照片与影片，您也可以追踪或观看其他51乱伦用户的照片与影片，亦可以发送私讯给其他51乱伦用户。当用户使用51乱伦相机功能拍摄照片或影片时，其内容对于51乱伦而言是专属独有的，您只能在51乱伦App中浏览内容，且无法分享或输出到51乱伦之外的地方。当用户于51乱伦中创建照片或影片（以下简称「内容」）时，内容创作者（以下简称「创作者」）可以让他/她的追随者（以下简称「追随者」）有偿或无偿观看其内容（以下简称分别为「免费内容」与「付费内容」）。针对付费内容，创作者会依照他/她期望收取的费用，设定一定数量的「51乱伦金币」，而51乱伦将从中收取些许平台服务费。追随者需要在App中购买等值「51乱伦金币」并完成支付才能观看该项内容。您可以在51乱伦中查询您的51乱伦金币余额（以下简称「余额」），"
              "\n您的余额包含： "
              "\n（一）您已购买/储值的51乱伦金币，但尚未花费于其他创作者的付费内容； "
              "\n（二）其他跟随者欲观看您的付费内容时所支付给您的51乱伦金币以及其他跟随者赠送给您的51乱伦金币（以下皆称为「收益」）。"
              "\n重要提示："
              "\n（一）我们不拥有或掌控51乱伦中的用户内容，所有在51乱伦中交易与互动的用户内容仅限于创作者与其追随者之间，51乱伦若依照法令规定或主播要求而删除任何内容时，用户不得异议； "
              "\n（二）若创作者通过平台举办各项私人活动，其内容与官方无关，官方亦无责补偿或退款。",
        ),
        _buildTitleUI("51乱伦使用对象"),
        _buildContentUI(
          "51乱伦是一个懂得尊重与负责的成年人的社交通讯平台，用户可创建任何的影片/照片/文字内容，其中可能包含成人资讯。"
              "\n当您开始使用51乱伦时，代表已了解App含有成人内容，且声明并保证："
              "\n（1）您至少年满十八岁；"
              "\n（2）您会完全遵守这些条款；"
              "\n（3）您接受在任何装置中使用51乱伦的全部责任，无论该装置是否归您所有；"
              "\n（4）您接受由您所创建或提供的任何内容的全部责任；"
              "\n（5）您在使用51乱伦时，不会违反这些条款或任何适用法律。",
        ),
        _buildTitleUI("帐号注册"),
        _buildContentUI(
          "您必须注册帐号才能进入并使用51乱伦，注册时，您必须提供有效的电子邮件地址、用户名称和密码。同时您也必须建立51乱伦个人资料与相关内容以完成您的51乱伦个人资料。请特别注意在建立帐号的过程中，我们可能会需要您的手机号码来进行帐号验证手续。",
        ),
        _buildContentUI(
          "在完成51乱伦注册前，您声明并保证：" +
              "\n（1）所有帐号注册的个人资料和内容（包含您从Facebook与Twitter或其他社群媒体服务中导入的内容），是由您提供给我们的真实个人资料与内容；" +
              "\n（2）您未曾注册或拥有过51乱伦帐号（包含您通过不同的电子邮件、用户名称或手机号码注册）；" +
              "\n（3）如您以前曾拥有过51乱伦帐号，您的旧帐号并未因违反这些条款而遭到暂停或终止；" +
              "\n（4）您在51乱伦注册的帐号是您属于您个人且合法的，您不会出售、出租、出借、或将您到帐号转移到任何未经本公司书面许可的其他人；" +
              "\n（5）您无法且您也不会试图通过未授权的第三方应用程式登入51乱伦。您会为您的帐号发生的所有行为承担全部责任，您有责任维护您的登入资讯的安全性与保密性，您也同意如果您认为有人未经您的许可使用或是正在使用您的帐户，或通过任何违反安全的方式引起您的注意，您会立即通知我们。",
        ),
        _buildTitleUI("在应用中购买"),
        _buildContentUI(
          "若要观看别人的付费内容，您必须在应用中购买并支付等值51乱伦金币。应用商城可能会取决于您住的地方收取销售税（详细资讯请查看您所属的应用商城的条款与政策）。重要提示：所有应用中购买的51乱伦金币是无法退款的。您明确了解并同意，您在51乱伦应用中购买51乱伦金币以观看付费内容，无论提供付费内容的创作者或是我们皆不会有任何责任义务为您提供任何理由的退款。您也同意我们只有在因51乱伦软体维修或其他技术故障而导致您的帐户余额错误时，才会进行必要的修正与调整。",
        ),
        _buildTitleUI("帐户停用"),
        _buildContentUI(
          "您自行停用如果您想要停用51乱伦帐户，请联系51乱伦客服：我们将在收到您的停用请求后的30个工作日内终止您的帐户。重要提示：当您的帐户停用后，帐户内剩余的51乱伦金币将被视为永久作废。遭官方停用您明确了解并同意我们保留权利在以下情况停用您的帐户："
              "\n（一）您在使用51乱伦时违反了这些条款或任何适用法律； "
              "\n（二）您超过60天未登入51乱伦，且经官方通知7日后仍未登入51乱伦。重要提示：若您的帐户因以上原因而遭到停用，帐户内剩余的51乱伦金币将被视为永久作废。",
        ),
        _buildTitleUI("禁止行为"),
        _buildContentUI(
          "我们要求所有51乱伦用户在任何时候使用51乱伦都能遵守条款。您不能使用51乱伦进行以下行为伪造帐户注册资料，或擅自使用他人的讯息或内以任何方式或任何目的从事非法行为，包含涉及任何违反个人或实体权利的行为：" +
              "• 创建、上传、发布、展示或传播任何以下用户内容："
                  "\n（一）侵犯他人著作权、商标权、隐私公开全或其他财产或人身权利（例如使用的姓名、肖像、图像或他人未经同意的身份）" +
              "\n• 创建、拷贝、复制、发布或修改任何不属于您或未经内容拥有者明确书面许可的内容（包含拍照或截图等） ；" +
              "\n• 反编译、逆向工程，或以其他任何方式试图挖掘获取的51乱伦原始码；" +
              "\n• 干扰任何51乱伦的伺服器、网路或系统相关营运，包含但不限于骇客攻击、垃圾邮件或进行服务攻 击、破坏或规避防火墙、加密机制、安全认证程序等，或试图观看您没有明确授权的讯息与他人帐户；" +
              "\n• 使用任何自动化程序、工具或程式（包含但不限于网路爬虫、机器人与自动化脚本）来进入51乱伦或51乱伦的任何伺服器、网路与相关系统；或从51乱伦中收集或取得内容或资讯；" +
              " \n• 使用51乱伦时进行任何违反本条款或任何适用法律的行为。" +
              "\n• 禁止利用任何行为，将51乱伦既有用户导引至新帐号或其他帐号消费（例如，不得鼓励51乱伦既有用户创新帐号储值，或是导引既有51乱伦用户通过非https：//wbcc.cc/以外连结或非官方认证方式进行51乱伦钻石金币购买）。违者及涉及此行为之用户将立即拔除该帐号使用权限，无条件收回其帐号之所有钻石金币，并需赔偿51乱伦相关损失。" +
              "如需回报51乱伦不当使用之行为，请联系51乱伦客服：",
        ),
        _buildTitleUI("侵权责任"),
        _buildContentUI(
          "• 51乱伦用户应确保51乱伦用户之任何上传内容，均系由51乱伦用户亲自独立构思及创作，绝无侵害任何人的权益，并且除了在51乱伦上从未被揭露过。51乱伦用户若有侵权之虞，应负防止侵害之责。" +
              "\n• 于51乱伦要求时，51乱伦用户应负责从51乱伦用户之任何上传内容的任何第三方权利拥有者（包括但不限于51乱伦用户之上传内容中所描绘或出现的任何人）取得任何必要之授权，支付任何相关费用，并应确保51乱伦得合法使用该权利。" +
              "\n• 51乱伦用户通过51乱伦上传之内容，纯属51乱伦用户个人行为，本公司对于上传内容而产生的一切纠纷不承担任何法律责任。",
        ),
        _buildTitleUI("适用法律与争议解决"),
        _buildContentUI(
          "本条款和本文所载的条款如有任何争议或歧见，应先进诚意协商解决，若无法达成协议，双方同意专属由台湾台北地方法院为管辖法院。您须在台湾台北地方法院解决因本协议或51乱伦而引起的任何导致诉讼行动或纠纷（索偿）的索赔和原因。",
        ),
      ],
    );

Widget _buildTitleUI(String title) => Container(
      margin: const EdgeInsets.only(top: 16),
      child: Text(
        title,
        style: _titleTextStyle,
      ),
    );

Widget _buildContentUI(String content) => Container(
      margin: const EdgeInsets.only(top: 4),
      child: Text(
        content,
        style: _contentTextStyle,
      ),
    );

const TextStyle _titleTextStyle = TextStyle(
  color: Colors.white54,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
const TextStyle _contentTextStyle = TextStyle(
  color: Colors.white38,
  fontSize: 14,
  height: 1.5,
);
