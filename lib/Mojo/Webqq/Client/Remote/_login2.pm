sub Mojo::Webqq::Client::_login2{
    my $self = shift;
    $self->info("尝试进行登录(阶段2)...\n");
    my $api_url = 'http://d.web2.qq.com/channel/login2';
    my $headers = {
        Referer     => 'http://d.web2.qq.com/proxy.html?v=20130916001&callback=1&id=2',
        json        => 1,
    };
    my %r = (
        status      =>  $self->state,
        ptwebqq     =>  $self->ptwebqq,
        clientid    =>  $self->clientid,
        psessionid  =>  $self->psessionid,  
    );    
    
    #if($self->{type} eq 'webqq'){
    #    $r{passwd_sig} = $self->passwd_sig;
    #}
    
    my $data = $self->http_post($api_url,$headers,form=>{r=>$self->encode_json(\%r)});
    return 0 unless defined $data;
    if($data->{retcode} ==0){
        $self->psessionid($data->{result}{psessionid})
             #->vfwebqq($data->{result}{vfwebqq})
             ->login_state('success')
             ->_cookie_proxy();
        return 1;
    }
    return 0;
}
1;
