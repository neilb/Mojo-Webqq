sub Mojo::Webqq::Client::_relink{
    my $self = shift;
    $self->login_state('relink');
    $self->info("正在进行重新连接...");
    my $api_url = 'http://d.web2.qq.com/channel/login2';
    my $headers = {Referer=>'http://d.web2.qq.com/proxy.html?v=20130916001&callback=1&id=2',json=>1};
    my %r = (
        status      =>  $self->state,
        key         =>  "",
        ptwebqq     =>  $self->ptwebqq,
        clientid    =>  $self->clientid,
        psessionid  =>  $self->psessionid,
    );    
    
    my $data = $self->http_post($api_url,$headers,form=>{r=>$self->encode_json(\%r)});
    unless(defined $data){
        $self->relogin();
        return 0;
    }
    if($data->{retcode} ==0){
        $self->psessionid($data->{result}{psessionid}) if $data->{result}{psessionid};
        $self->vfwebqq($data->{result}{vfwebqq}) if $data->{result}{vfwebqq};
        $self->clientid($data->{result}{clientid}) if $data->{result}{clientid};
        $self->ptwebqq($data->{result}{ptwebqq}) if $data->{result}{ptwebqq};
        $self->skey($data->{result}{skey}) if $data->{result}{skey};
        $self->ua->cookie_jar->add(
            Mojo::Cookie::Response->new(
                name => "ptwebqq",
                value => $data->{result}{ptwebqq},
                domain => "qq.com",
                path  => "/",
            ),  
        );
        $self->_cookie_proxy();
        $self->login_state('success');
        $self->info("重新连接成功");
        return 1;
    }
    else{
        $self->relogin();
        return 0;
    }
}
1;
