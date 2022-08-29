VERSION 5.00
Object = "{7020C36F-09FC-41FE-B822-CDE6FBB321EB}#1.2#0"; "vbccr17.ocx"
Begin VB.Form frmMain 
   BackColor       =   &H80000005&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "EasyZeroTier | 0.0.1 By ��һ��ն��"
   ClientHeight    =   5355
   ClientLeft      =   45
   ClientTop       =   390
   ClientWidth     =   10080
   BeginProperty Font 
      Name            =   "Microsoft YaHei UI"
      Size            =   10.5
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5355
   ScaleWidth      =   10080
   StartUpPosition =   3  '����ȱʡ
   Begin VB.CommandButton btnStartMoon 
      Caption         =   "ʹ�ñ����Խ�������"
      Height          =   495
      Left            =   120
      TabIndex        =   11
      Top             =   4680
      Width           =   2295
   End
   Begin VB.CommandButton btnLeaveMoon 
      Caption         =   "�˳��Խ�������"
      Height          =   495
      Left            =   120
      TabIndex        =   10
      Top             =   4080
      Width           =   2295
   End
   Begin VB.CommandButton btnJoinMoon 
      Caption         =   "�����Խ�������"
      Height          =   495
      Left            =   120
      TabIndex        =   9
      Top             =   3480
      Width           =   2295
   End
   Begin VB.CommandButton btnExitNetwork 
      Caption         =   "�˳�����"
      Height          =   495
      Left            =   1320
      TabIndex        =   8
      Top             =   2760
      Width           =   1095
   End
   Begin VB.CommandButton btnRefreshNetworks 
      Caption         =   "ˢ��"
      Height          =   495
      Left            =   3360
      TabIndex        =   5
      Top             =   2760
      Width           =   975
   End
   Begin VBCCR17.ListView lstNetworks 
      Height          =   1695
      Left            =   120
      TabIndex        =   4
      Top             =   960
      Width           =   4215
      _ExtentX        =   7435
      _ExtentY        =   2990
      VisualTheme     =   1
      View            =   3
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
   End
   Begin VB.CommandButton btnJoinNetwork 
      Caption         =   "��������"
      Height          =   495
      Left            =   120
      TabIndex        =   3
      Top             =   2760
      Width           =   1095
   End
   Begin VBCCR17.ListView lstPeers 
      Height          =   4215
      Left            =   4560
      TabIndex        =   6
      Top             =   960
      Width           =   5415
      _ExtentX        =   9551
      _ExtentY        =   7435
      VisualTheme     =   1
      View            =   3
      FullRowSelect   =   -1  'True
      GridLines       =   -1  'True
      HideColumnHeaders=   -1  'True
   End
   Begin VB.Label Label1 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "��Ա�б�"
      Height          =   375
      Left            =   6000
      TabIndex        =   7
      Top             =   600
      Width           =   3975
   End
   Begin VB.Label lblServerList 
      BackStyle       =   0  'Transparent
      Caption         =   "�����б�"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   600
      Width           =   3975
   End
   Begin VB.Label lblZeroTierVersion 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "lblZeroTierVersion"
      Height          =   375
      Left            =   6000
      TabIndex        =   1
      Top             =   120
      Width           =   3975
   End
   Begin VB.Label lblMyAddress 
      BackStyle       =   0  'Transparent
      Caption         =   "myaddress"
      Height          =   375
      Left            =   120
      TabIndex        =   0
      Top             =   120
      Width           =   7935
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Public AddressCaption As String

Private Sub btnExitNetwork_Click()
'�뿪����
If MsgBox("�����Ƿ�Ҫ�˳����� " & lstNetworks.SelectedItem.Text & " ?", vbQuestion + vbYesNo) = vbYes Then
ZeroTierCLI.Query ("leave " & lstNetworks.SelectedItem.key)
UpdateNetworks
End If
End Sub

Private Sub btnJoinMoon_Click()
'����moon
If Dir(ZeroTierPath & "\moons.d", vbDirectory) = "" Then MkDir ZeroTierPath & "\moons.d"
Dim MoonFile As String, MoonFileName As String, MoonID As String, RetVal As String
MoonFile = ""
Do While MoonFile = ""
    MoonFile = ChooseFile("ѡ���Խ�������ǩ���ļ�", "�Խ�������ǩ���ļ�", "*.moon", Me.hwnd)
Loop
MoonFileName = GetFileNameFromPath(MoonFile)
MoonID = Right(Left(MoonFileName, 16), 10)
FileCopy MoonFile, ZeroTierPath & "\moons.d\" & MoonFileName
Sleep 100
RetVal = ZeroTierCLI.QueryRaw("orbit " & MoonID & " " & MoonID)
If Left(RetVal, 3) = "200" Then
MsgBox "������ϡ�", vbInformation
Else
MsgBox RetVal, vbCritical
End If
    UpdateNetworks
    UpdatePeers
End Sub

Private Sub btnLeaveMoon_Click()
'�˳�moon
If Dir(ZeroTierPath & "\moons.d", vbDirectory) = "" Then MkDir ZeroTierPath & "\moons.d"
Dim MoonFile As String, MoonFileName As String, MoonID As String, RetVal As String
MoonFile = ""
Do While MoonFile = ""
    MoonFile = ChooseFile("ѡ���Խ�������ǩ���ļ�", "�Խ�������ǩ���ļ�", "*.moon", Me.hwnd)
Loop
MoonFileName = GetFileNameFromPath(MoonFile)
MoonID = Right(Left(MoonFileName, 16), 10)
FileCopy MoonFile, ZeroTierPath & "\moons.d\" & MoonFileName
Sleep 100
RetVal = ZeroTierCLI.QueryRaw("deorbit " & MoonID)
If InStr(RetVal, "true") Then
MsgBox "�˳���ϡ�", vbInformation
Else
MsgBox RetVal, vbCritical
End If
    UpdateNetworks
    UpdatePeers
End Sub

Private Sub btnRefreshNetworks_Click()
    UpdateNetworks
    UpdatePeers
End Sub

Private Sub btnStartMoon_Click()
If MsgBox("�Ƿ��ñ����Խ�������?" & vbCrLf & "��ȷ���򿪹�è�� UPnP ���ܣ�" & vbCrLf & vbCrLf & "EasyZeroTier �Դ�����������֧����ʵ���Եģ�������ʾ�����ɹ�������Ȼʧ�ܡ�", vbQuestion + vbYesNo) = vbNo Then Exit Sub
btnStartMoon.Caption = "���ڲ��� IP"

Dim Tmp As Variant
Dim TestedIP As String

With New MSXML2.ServerXMLHTTP30
.Open "GET", "http://api.ip.sb", False
.setRequestHeader "User-Agent", "curl"
.send
TestedIP = Replace(Replace(.responseText, vbLf, ""), vbCr, "")
End With

If Left(TestedIP, 2) = 10 Then
MsgBox "����û�й��� IP���޷��Խ� ZeroTier ��������", vbCritical
GoTo ExitCreateMoon
End If

btnStartMoon.Caption = "���ڳ��� UPnP ��"

Dim LocalIP As String
ShellAndWait "cmd /c ipconfig /all > " & QUOT & Environ("LocalAppData") & "\Temp\EZT.txt" & QUOT
Tmp = Split(Filter(Split(ReadTextFile(Environ("LocalAppData") & "\Temp\EZT.txt"), vbCrLf), "IPv4")(0), " ")
LocalIP = Split(Tmp(UBound(Tmp) - 1), "(")(0)

ShellAndWait "cmd /c " & QUOT & QUOT & App.Path & "\upnpc-shared.exe" & QUOT & " -a " & LocalIP & " 9993 9993 udp -i > " & QUOT & Environ("LocalAppData") & "\Temp\EZT.txt" & QUOT & " 2> " & QUOT & Environ("LocalAppData") & "\Temp\EZT2.txt" & QUOT & QUOT
Tmp = ReadTextFile(Environ("LocalAppData") & "\Temp\EZT.txt") & vbCrLf & ReadTextFile(Environ("LocalAppData") & "\Temp\EZT2.txt")

MsgBox "���� UPnP �򶴣���־����" & vbCrLf & "======================================" & vbCrLf & Tmp

Dim MoonJSON As String, MoonID As String
If InStr(Tmp, "is redirected to internal") Then
'��ʼ��moon����
    MoonJSON = ZeroTierCLI.IDToolRaw("initmoon " & QUOT & ZeroTierPath & "\identity.public" & QUOT)
    MoonJSON = Replace(MoonJSON, QUOT & "stableEndpoints" & QUOT & ": []", QUOT & "stableEndpoints" & QUOT & ": [" & QUOT & TestedIP & "/9993" & QUOT & "]")
    Open App.Path & "\moon.json" For Output As #2
        Print #2, MoonJSON;
    Close #2
    MoonID = JSON.parse(MoonJSON)("id")
    MsgBox "����������ǩ���ļ�����־����" & vbCrLf & ZeroTierCLI.IDToolRaw("genmoon " & QUOT & App.Path & "\moon.json" & QUOT)
    'FileCopy ZeroTierPath & "\000000" & MoonID & ".moon", App.Path & "\000000" & MoonID & ".moon"
    MsgBox "�Խ��������ɹ���" & vbCrLf & "�����Խ���������ǩ���ļ��Ѿ������ڳ����ļ��У����͸����˼���ʹ�ã��Լ�Ҳ���Լ��롣" & vbCrLf & vbCrLf & "000000" & MoonID & ".moon", vbInformation
Else
    MsgBox "�Խ�������ʧ�ܣ�" & vbCrLf & "��ǰ���绷��������ʹ�� UPnP �򶴡�", vbCritical
End If

ExitCreateMoon:
btnStartMoon.Caption = "ʹ�ñ����Խ�������"
Exit Sub
End Sub

Private Sub Form_Load()
    ZeroTierCLI.Init
    InitUI
    UpdateNetworks
    UpdatePeers
End Sub

Private Sub InitUI()
    Dim QueryInfo As Object
On Error GoTo ReInit
ReInit:
    Set QueryInfo = ZeroTierCLI.Query("info")
    AddressCaption = "�豸��ַ: " & QueryInfo("address")
    lblMyAddress.Caption = AddressCaption
    lblZeroTierVersion.Caption = "ZeroTier " & QueryInfo("version")
    With lstPeers
        .ListItems.Clear
        .ColumnHeaders.Clear
        .ColumnHeaders.Add 1, "name", "�豸����", 2500
        .ColumnHeaders.Add 2, "role", "��ɫ", 1700
        .ColumnHeaders.Add 3, "latency", "�ӳ�", 1150
    End With
    
    With lstNetworks
        .ListItems.Clear
        .ColumnHeaders.Clear
        .ColumnHeaders.Add 1, "name", "��������", 3000
        .ColumnHeaders.Add 2, "status", "״̬", 1150
    End With
End Sub

Private Sub UpdateNetworks()
On Error GoTo ExitSub
    Dim NetworksQuery As Object, Network As Variant
    Dim i As Integer
    Set NetworksQuery = ZeroTierCLI.Query("listnetworks")
    With lstNetworks
        .ListItems.Clear
        If JSON.toString(NetworksQuery) = "[]" Then
            .ListItems.Add 1, , "��ǰ��δ�����κ�����"
        Else
            i = 1
            For Each Network In NetworksQuery
                If Network("name") = "" Then
                    .ListItems.Add i, Network("nwid"), "(�ȴ�����Աͬ��)"
                Else
                    With New cUTF8
                        lstNetworks.ListItems.Add i, Network("nwid"), .DecodeUTF8(Network("name"))
                    End With
                End If
                .ListItems(i).ToolTipText = .ListItems(i).Text
                .ListItems(i).SubItems(1) = ZeroTierCLI.StatusToReadable(Network("status"))
                i = i + 1
            Next
        End If
    End With
ExitSub:
    Exit Sub
End Sub

Private Sub UpdatePeers()
    Dim MoonExists As Boolean, MoonAddress As String
    MoonExists = False
    Dim PeersQuery As Object, Peer As Variant
    Dim i As Integer
    Set PeersQuery = ZeroTierCLI.Query("listpeers")
    With lstPeers
        .ListItems.Clear
        If JSON.toString(PeersQuery) = "[]" Then
            .ListItems.Add 1, , "��ǰ����û�г�Ա"
        Else
            i = 1
            For Each Peer In PeersQuery
                .ListItems.Add i, Peer("address"), Peer("address")
                .ListItems(i).ToolTipText = .ListItems(i).Text

                Select Case Peer("role")
                Case "LEAF": .ListItems(i).SubItems(1) = "��Ա"
                Case "PLANET": .ListItems(i).SubItems(1) = "���ķ�����"
                Case "MOON"
                    .ListItems(i).SubItems(1) = "�Խ�������"
                    MoonExists = True
                    MoonAddress = Peer("address")
                Case Else: .ListItems(i).SubItems(1) = Peer("role")
                End Select
                
                If Peer("latency") = 0 Then
                    .ListItems(i).SubItems(2) = "(����)"
                ElseIf Peer("latency") < 0 Then
                    .ListItems(i).SubItems(2) = "(����)"
                Else
                    .ListItems(i).SubItems(2) = str(Peer("latency")) & "ms"
                End If
                i = i + 1
            Next
        End If
    End With
    If MoonExists Then
        lblMyAddress.Caption = AddressCaption & " | ����ʹ���Խ������� " & MoonAddress
    Else
        lblMyAddress.Caption = AddressCaption & " | ����ʹ�����ķ�����"
    End If
End Sub

Private Sub btnJoinNetwork_Click()
'��������
    Dim JoinQuery As Object, NetworkID As String
    NetworkID = InputBox("��������Ҫ��������� ID", "EasyZeroTier", "16 λ���� ID")
    MsgBox ("������������������֪ͨ��ѯ�ʡ��Ƿ���������豸�������豸���֣���������������")
    Set JoinQuery = ZeroTierCLI.Query("join " & NetworkID)
    If JSON.toString(JoinQuery) = "" Then
        MsgBox "��������ʧ�ܣ����������� ID ����ȷ��", vbCritical
    Else
        If JoinQuery("type") = "PRIVATE" Then
            MsgBox "����ɹ�����ȴ��������Աȷ�ϡ�", vbInformation
        Else
            MsgBox "����ɹ���", vbInformation
        End If
    End If
UpdateNetworks
End Sub

Private Sub lstPeers_ContextMenu(ByVal x As Single, ByVal Y As Single)
    Dim PeersQuery As Object, Peer As Variant, Path As Variant, WndName As String, pid As Long, tmphWnd As Long
    Set PeersQuery = ZeroTierCLI.Query("listpeers")
    For Each Peer In PeersQuery
        If Peer("address") = lstPeers.SelectedItem.Text Then
            If Peer("role") = "LEAF" Then
                For Each Path In Peer("paths")
                    If Path("active") And Not Path("expired") Then
                        WndName = "���Ե� " & Peer("address") & " �������ӳ�"
                        pid = Shell("cmd /c mode con cols=75 lines=20 && color f0 && title " & WndName & " && echo.���ڲ��������ӳ�... && echo.����ӳٹ���˵�������ķ�������ת��&& echo.�뿼���Խ������� & ping " & Split(Path("address"), "/")(0) & " && pause >nul", vbNormalFocus)
                        Exit Sub
                    End If
                Next
                MsgBox "�ó�Ա�����ߣ�δ�����佨���ɿ����ӣ��޷������ӳ�", vbCritical
            Else
                For Each Path In Peer("paths")
                    If Path("active") And Not Path("expired") Then
                        WndName = "���Ե������� " & Peer("address") & " �������ӳ�"
                        pid = Shell("cmd /c mode con cols=75 lines=20 && color f0 && title " & WndName & " && echo.���ڲ��������ӳ�... && echo.�����ķ��������ӳٹ�������������&& echo.����޷������뿼���Խ������� & ping " & Split(Path("address"), "/")(0) & " && pause >nul", vbNormalFocus)
                        Exit Sub
                    End If
                Next
                MsgBox "��̨�����������ߣ�δ�����佨���ɿ����ӣ��޷������ӳ�", vbCritical
            End If
        End If
    Next
End Sub
