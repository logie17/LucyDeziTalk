{
    engine_config => {
        fields          => ['key','value',],
        link            => "http://localhost:6000",
        indexer_config  => {
            config  => {
                MetaNames       => 'key value',
                PropertyNames   => 'key value',
            }
        }
    }
}
