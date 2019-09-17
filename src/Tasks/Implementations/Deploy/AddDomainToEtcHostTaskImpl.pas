(*!------------------------------------------------------------
 * Fano CLI Application (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano-cli
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
 *------------------------------------------------------------- *)
unit AddDomainToEtcHostTaskImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    TaskOptionsIntf,
    TaskIntf,
    FileContentReaderIntf,
    FileContentWriterIntf;

type

    (*!--------------------------------------
     * Task that adds domain name entry to /etc/hosts
     *------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------*)
    TAddDomainToEtcHostTask = class(TInterfacedObject, ITask)
    private
        fReader : IFileContentReader;
        fWriter : IFileContentWriter;

        function getIp(const opt : ITaskOptions) : string;
    public
        constructor create(
            const afreader : IFileContentReader;
            const afwriter : IFileContentWriter
        );
        destructor destroy(); override;

        function run(
            const opt : ITaskOptions;
            const longOpt : shortstring
        ) : ITask;
    end;

implementation

uses

    SysUtils;

    constructor TAddDomainToEtcHostTask.create(
        const afreader : IFileContentReader;
        const afwriter : IFileContentWriter
    );
    begin
        fReader := afreader;
        fWriter := afwriter;
    end;

    destructor TAddDomainToEtcHostTask.destroy();
    begin
        fReader := nil;
        fWriter := nil;
        inherited destroy();
    end;

    function TAddDomainToEtcHostTask.getIp(const opt : ITaskOptions) : string;
    begin
        result := opt.getOptionValue('server-ip');
        if result = '' then
        begin
            result := '127.0.0.1';
        end;
    end;

    function TAddDomainToEtcHostTask.run(
        const opt : ITaskOptions;
        const longOpt : shortstring
    ) : ITask;
    var serverName : string;
        serverIp : string;
        etcHosts : string;
    begin
        serverName := opt.getOptionValue(longOpt);
        serverIp := getIp(opt);
        //create domain entry in /etc/hosts
        etcHosts := fReader.read('/etc/hosts');
        etcHosts := etcHosts + LineEnding +
                serverIp + ' ' + serverName + LineEnding;
        fWriter.write('/etc/hosts', etcHosts);
        writeln('Add ' + serverIp + ' ' + serverName +' to /etc/hosts ');
        result := self;
    end;
end.
