return {
	DOC_QUERY = [[
        ((document filename: (filename (string) @beancount-capture)))
    ]],
	TXN_QUERY = [[
    ((transaction 
        date: (date)
        narration: (narration)
            (posting 
                account: (account)
                amount: (incomplete_amount))) @beancount-capture )
    ]],
}
