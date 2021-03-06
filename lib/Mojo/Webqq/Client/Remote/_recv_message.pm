sub Mojo::Webqq::Client::_recv_message{
    my $self = shift;
    return if $self->is_stop;
    my $api_url = ($self->security?'https':'http') . '://d.web2.qq.com/channel/poll2';
    my $callback = sub {
        my $json = shift;
        #分析接收到的消息，并把分析后的消息放到接收消息队列中
        $self->parse_receive_msg($json) if defined $json;
        #重新开始接收消息
        $self->_recv_message();
    };

    my %r = (
        clientid    =>  $self->clientid,
        psessionid  =>  $self->psessionid,
        key         =>  "",
    );
    my $headers = {Referer=>"http://d.web2.qq.com/proxy.html?v=20130916001&callback=1&id=2",json=>1};
    $self->http_post(
        $api_url,   
        $headers,
        form=>{r=>$self->encode_json(\%r)},
        $callback
    );
     
}
1;
