-- ============================================
-- FULL PETRA BRANDS EMPLOYEE LIST
-- Total: 56 employees across 6 countries
-- ============================================

-- Clear existing employees (except those with reports)
DELETE FROM employees WHERE role != 'owner';

-- Insert all employees
INSERT INTO employees (email, name, location, department, role, manager_id) VALUES
    ('abdul.basit@petrabrands.com', 'Abdul Basit', 'Pakistan', 'Financial Management', 'employee', NULL),
    ('abdullah.khan@petrabrands.com', 'Abdullah Khan', 'Pakistan', 'Business Management', 'employee', NULL),
    ('alexa.black@petrabrands.com', 'Alexa Black', 'USA', 'Business Management', 'employee', NULL),
    ('angela.aquino@petrabrands.com', 'Angela Aquino', 'Philippines', 'Business Management', 'employee', NULL),
    ('athar.ehsan@petrabrands.com', 'Athar Ehsan', 'Pakistan', 'Creative Management', 'employee', NULL),
    ('awais.rasheed@petrabrands.com', 'Awais Rasheed', 'Pakistan', 'Business Management', 'employee', NULL),
    ('bilal.ahmad@petrabrands.com', 'Bilal Ahmad', 'Pakistan', 'Business Management', 'employee', NULL),
    ('bushra.khawaja@petrabrands.com', 'Bushra Khawaja', 'Pakistan', 'People Management', 'hr', NULL),
    ('daniyal.karim@petrabrands.com', 'Daniyal Karim', 'Pakistan', 'Financial Management', 'employee', NULL),
    ('shehar.yar.mubashir@petrabrands.com', 'Shehar Yar Mubashir', 'Pakistan', 'Financial Management', 'employee', NULL),
    ('fahad.ali.mustafa@petrabrands.com', 'Fahad Ali Mustafa', 'Pakistan', 'Business Management', 'employee', NULL),
    ('hajra.noor@petrabrands.com', 'Hajra Noor', 'Pakistan', 'People Management', 'employee', NULL),
    ('hamza.iqbal@petrabrands.com', 'Hamza Iqbal', 'Pakistan', 'Supply Chain Management', 'employee', NULL),
    ('hope.erickson@petrabrands.com', 'Hope Erickson', 'USA', 'Supply Chain Management', 'employee', NULL),
    ('isaiah.sumano@petrabrands.com', 'Isaiah Sumano', 'USA', 'Supply Chain Management', 'employee', NULL),
    ('kateyrna.rotko@petrabrands.com', 'Kateyrna Rotko', 'Canada', 'Creative Management', 'employee', NULL),
    ('layeba.naeem@petrabrands.com', 'Layeba Naeem', 'Pakistan', 'People Management', 'employee', NULL),
    ('manuel.angel@petrabrands.com', 'Manuel Angel', 'USA', 'Supply Chain Management', 'employee', NULL),
    ('mark.collins@petrabrands.com', 'Mark Collins', 'Canada', 'Supply Chain Management', 'employee', NULL),
    ('mir.sachal@petrabrands.com', 'Mir Sachal', 'Pakistan', 'Creative Management', 'employee', NULL),
    ('muhammad.umar.masoom@petrabrands.com', 'Muhammad Umar Masoom', 'Pakistan', 'Financial Management', 'employee', NULL),
    ('myroslava.kondratiuk@petrabrands.com', 'Myroslava Kondratiuk', 'Canada', 'Creative Management', 'employee', NULL),
    ('ramiz.nasir@petrabrands.com', 'Ramiz Nasir', 'Pakistan', 'Supply Chain Management', 'employee', NULL),
    ('rihab.ourahou@petrabrands.com', 'Rihab Ourahou', 'Canada', 'Creative Management', 'employee', NULL),
    ('sahar.mumtaz@petrabrands.com', 'Sahar Mumtaz', 'Pakistan', 'Product Management', 'employee', NULL),
    ('sajawal.shoukat@petrabrands.com', 'Sajawal Shoukat', 'Pakistan', 'Financial Management', 'employee', NULL),
    ('shahzaib.shahid@petrabrands.com', 'Shahzaib Shahid', 'Pakistan', 'Creative Management', 'employee', NULL),
    ('sophie.dong@petrabrands.com', 'Sophie Dong', 'China', 'Business Management', 'employee', NULL),
    ('sulaiman.muhammad@petrabrands.com', 'Sulaiman Muhammad', 'Pakistan', 'Business Management', 'employee', NULL),
    ('tristian.orum@petrabrands.com', 'Tristian Orum', 'USA', 'Supply Chain Management', 'employee', NULL),
    ('varun.arora@petrabrands.com', 'Varun Arora', 'USA', 'Operations Management', 'employee', NULL),
    ('ahmad.faraz@petrabrands.com', 'Ahmad Faraz', 'Pakistan', 'Financial Management', 'employee', NULL),
    ('zuzanna.rutkowska@petrabrands.com', 'Zuzanna Rutkowska', 'Poland', 'Creative Management', 'employee', NULL),
    ('mursal.khedri@petrabrands.com', 'Mursal Khedri', 'China', 'Top management', 'owner', NULL),
    ('ali.kaaba@petrabrands.com', 'Ali Kaaba', 'China', 'Top management', 'owner', NULL),
    ('rita.shi@petrabrands.com', 'Rita Shi', 'China', 'Top management', 'owner', NULL),
    ('maira.mumtaz@petrabrands.com', 'Maira Mumtaz', 'China', 'Financial Management', 'employee', NULL),
    ('carey.guo@petrabrands.com', 'Carey Guo', 'China', 'Financial Management', 'employee', NULL),
    ('morpheus.qiu@petrabrands.com', 'Morpheus Qiu', 'China', 'People Management', 'hr', NULL),
    ('holly.huang@petrabrands.com', 'Holly Huang', 'China', 'Supply Chain Management', 'employee', NULL),
    ('elsie.liang@petrabrands.com', 'Elsie Liang', 'China', 'Supply Chain Management', 'employee', NULL),
    ('ian.wang@petrabrands.com', 'Ian Wang', 'China', 'Supply Chain Management', 'employee', NULL),
    ('shay.wu@petrabrands.com', 'Shay Wu', 'China', 'Supply Chain Management', 'employee', NULL),
    ('vanessa.chen@petrabrands.com', 'Vanessa Chen', 'China', 'Supply Chain Management', 'employee', NULL),
    ('jun.mu@petrabrands.com', 'Jun Mu', 'China', 'Supply Chain Management', 'employee', NULL),
    ('ming.xue@petrabrands.com', 'Ming Xue', 'China', 'Supply Chain Management', 'employee', NULL),
    ('linda.xie@petrabrands.com', 'Linda Xie', 'China', 'Supply Chain Management', 'employee', NULL),
    ('frank.pan@petrabrands.com', 'Frank Pan', 'China', 'Supply Chain Management', 'employee', NULL),
    ('jim.liu@petrabrands.com', 'Jim Liu', 'China', 'Supply Chain Management', 'employee', NULL),
    ('sheikh.liu@petrabrands.com', 'Sheikh Liu', 'China', 'Creative management', 'employee', NULL),
    ('suki.su@petrabrands.com', 'Suki Su', 'China', 'Creative management', 'employee', NULL),
    ('neil.zhou@petrabrands.com', 'Neil Zhou', 'China', 'Creative management', 'employee', NULL),
    ('chris.chen@petrabrands.com', 'Chris Chen', 'China', 'Business management', 'employee', NULL),
    ('jemmy.yao@petrabrands.com', 'Jemmy Yao', 'China', 'Business management', 'employee', NULL),
    ('jack.yu@petrabrands.com', 'Jack Yu', 'China', 'Business management', 'employee', NULL),
    ('catherine.zhao@petrabrands.com', 'Catherine Zhao', 'China', 'Business management', 'employee', NULL);

-- Verify count
SELECT 'Total employees:' as info, COUNT(*) as count FROM employees;
SELECT 'By location:' as info, location, COUNT(*) as count FROM employees GROUP BY location ORDER BY count DESC;
SELECT 'By role:' as info, role, COUNT(*) as count FROM employees GROUP BY role ORDER BY count DESC;
