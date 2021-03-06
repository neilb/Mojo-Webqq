use lib "../lib";
use Mojo::Webqq;
use Mojo::Util qw(md5_sum);

#初始化一个客户端对象
my $client=Mojo::Webqq->new(ua_debug=>0);

my $qq = 12345678;
my $pwd = "your password";

my $pwd_md5 = md5_sum($pwd);#得到原始密码的32位长度md5

#客户端进行登录
$client->login(qq=>$qq,pwd=>$pwd_md5);

#客户端加载ShowMsg插件，用于打印发送和接收的消息到终端
$client->load("ShowMsg");

#设置接收消息事件的回调函数，在回调函数中对消息以相同内容进行回复
$client->on(receive_message=>sub{
    my ($client,$msg)=@_;
    #已以相同内容回复接收到的消息
    $client->reply_message($msg,$msg->content);
    #你也可以使用$msg->dump() 来打印消息结构
});

#客户端开始运行
$client->run();
